import { Prisma, PrismaClient, User } from "@prisma/client";
import { Hono } from "hono";
import {
	loginSchema,
	resetPasswordRequestSchema,
	resetPasswordSchema,
	signupSchema,
} from "../schemas";
import { hash, verify } from "@node-rs/argon2";
import { authMiddleware } from "../middlewares/auth";
import { render } from "@react-email/components";
import ResetPasswordEmail from "../emails/reset-password";
import {
	argonOptions,
	RESET_PASSWORD_EXPIRES_IN_MS,
	SESSION_EXPIRES_IN_MS,
} from "../utils/constants";
import { sha256HexDigest } from "../utils";
import transporter from "../services/email";
import prisma from "../services/db";
import {
	ArcticFetchError,
	generateCodeVerifier,
	generateState,
	OAuth2RequestError,
} from "arctic";
import { google } from "../services/oauth";
import { getCookie, setCookie } from "hono/cookie";
import { GoogleUser } from "../types";

const app = new Hono();

app.post("/signup", async (c) => {
	const body = await c.req.parseBody();
	const form = signupSchema.safeParse(body);

	if (!form.success) {
		return c.json({ error: form.error.flatten() }, 400);
	}

	const { name, email, password } = form.data;
	const passwordHash = await hash(password, argonOptions);

	try {
		await prisma.user.create({
			data: {
				name: name,
				email: email,
				password: passwordHash,
			},
		});

		return c.json({ message: "User created" });
	} catch (e) {
		if (e instanceof Prisma.PrismaClientKnownRequestError) {
			if (e.code === "P2002") {
				return c.json({ error: "Email already exists" }, 400);
			}
		}
		throw e;
	}
});

app.post("/login", async (c) => {
	const body = await c.req.parseBody();
	const form = loginSchema.safeParse(body);

	if (!form.success) {
		return c.json({ error: form.error.flatten() }, 400);
	}

	const { email, password } = form.data;
	const user = await prisma.user.findUnique({
		where: {
			email: email,
		},
	});

	if (!user) {
		return c.json({ error: "Invalid email or password" }, 400);
	}

	const isValidPassword = !!user.password
		? await verify(user.password, password)
		: false;
	if (!isValidPassword) {
		return c.json({ error: "Invalid email or password" }, 400);
	}

	const session = await prisma.session.create({
		data: {
			userId: user.id,
			expiresAt: new Date(Date.now() + SESSION_EXPIRES_IN_MS),
		},
	});

	return c.json({ session });
});

app.get("/google", async (c) => {
	const state = generateState();
	const codeVerifier = generateCodeVerifier();
	const url = google.createAuthorizationURL(state, codeVerifier, [
		"email",
		"profile",
		"openid",
	]);

	setCookie(c, "state", state, {
		path: "/",
		secure: process.env.NODE_ENV === "production",
		httpOnly: true,
		maxAge: 60 * 10, // 10 minutes
		sameSite: "lax",
	});

	setCookie(c, "codeVerifier", codeVerifier, {
		path: "/",
		secure: process.env.NODE_ENV === "production",
		httpOnly: true,
		maxAge: 60 * 10, // 10 minutes
		sameSite: "lax",
	});

	return c.redirect(url.toString(), 302);
});

app.get("/google/callback", async (c) => {
	const { state, code } = c.req.query();
	const storedState = getCookie(c, "state");
	const storedCodeVerifier = getCookie(c, "codeVerifier");

	if (!code || !storedState || !storedCodeVerifier || state !== storedState) {
		return c.json({ error: "Invalid state or code" }, 400);
	}

	try {
		const tokens = await google.validateAuthorizationCode(
			code,
			storedCodeVerifier
		);

		const response = await fetch(
			"https://openidconnect.googleapis.com/v1/userinfo",
			{
				headers: {
					Authorization: `Bearer ${tokens.accessToken()}`,
				},
			}
		);
		const googleUser = (await response.json()) as GoogleUser;

		const existingAccount = await prisma.connection.findFirst({
			where: {
				provider: "google",
				providerUserId: googleUser.sub,
			},
		});

		let createdUser: User | null = null;
		if (!existingAccount) {
			createdUser = await prisma.user.create({
				data: {
					email: googleUser.email,
					name: googleUser.name,
					Connections: {
						create: {
							provider: "google",
							providerUserId: googleUser.sub,
						},
					},
				},
			});
		}

		const session = await prisma.session.create({
			data: {
				userId: createdUser?.id ?? existingAccount!.userId,
				expiresAt: new Date(Date.now() + SESSION_EXPIRES_IN_MS),
			},
		});

		return c.json({ session });
	} catch (e) {
		if (
			e instanceof OAuth2RequestError &&
			e.message === "bad_verification_code"
		) {
			return c.json({ error: "Invalid code" }, 400);
		} else if (e instanceof Prisma.PrismaClientKnownRequestError) {
			if (e.code === "P2002") {
				return c.json({ error: "Email already exists" }, 400);
			}
		}
		throw e;
	}
});

app.post("/logout", authMiddleware, async (c) => {
	const session = c.get("session")!;

	await prisma.session.delete({
		where: { id: session.id },
	});

	return c.json({ message: "Logged out" });
});

app.post("/reset-password", async (c) => {
	const body = await c.req.parseBody();
	const form = resetPasswordRequestSchema.safeParse(body);

	if (!form.success) {
		return c.json({ error: form.error.flatten() }, 400);
	}

	const { email } = form.data;
	const user = await prisma.user.findUnique({
		where: { email },
	});

	if (!user) {
		return c.json({ error: "User not found" }, 404);
	}

	const tokenId = crypto.randomUUID();
	const tokenHash = await sha256HexDigest(tokenId);

	await prisma.passwordResetToken.create({
		data: {
			tokenHash: tokenHash,
			userId: user.id,
			expiresAt: new Date(Date.now() + RESET_PASSWORD_EXPIRES_IN_MS),
		},
	});

	const resetLink = `${process.env.FRONTEND_URL}/reset-password/${tokenId}`;
	const component = ResetPasswordEmail({ resetPasswordLink: resetLink });
	const emailHtml = await render(component);
	const emailText = await render(component, { plainText: true });

	await transporter.sendMail({
		from: "sender@example.com",
		to: email,
		subject: "Reset password",
		html: emailHtml,
		text: emailText,
	});

	return c.json({ message: "Email sent" });
});

app.post("/reset-password/:token", async (c) => {
	const body = await c.req.parseBody();
	const form = resetPasswordSchema.safeParse(body);
	const token = c.req.param("token");

	if (!form.success) {
		return c.json({ error: form.error.flatten() }, 400);
	}

	const tokenHash = await sha256HexDigest(token);
	const passwordResetToken = await prisma.passwordResetToken.findUnique({
		where: { tokenHash: tokenHash },
	});

	if (!passwordResetToken || passwordResetToken.expiresAt < new Date()) {
		return c.json({ error: "Invalid token" }, 400);
	}

	await prisma.passwordResetToken.delete({
		where: { tokenHash: passwordResetToken.tokenHash },
	});

	const { password } = form.data;
	const passwordHash = await hash(password, argonOptions);

	await prisma.session.deleteMany({
		where: { userId: passwordResetToken.userId },
	});

	await prisma.user.update({
		where: { id: passwordResetToken.userId },
		data: { password: passwordHash },
	});

	return c.json({ message: "Password updated" });
});

export default app;
