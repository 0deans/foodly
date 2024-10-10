import { Prisma, PrismaClient } from "@prisma/client";
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
import transporter from "../services/email";
import { UserResponseDTO } from "../types";

const app = new Hono();
const prisma = new PrismaClient();

app.post("/signup", async (c) => {
	const body = await c.req.parseBody();
	const form = signupSchema.safeParse(body);

	if (!form.success) {
		return c.json({ error: form.error.flatten() }, 400);
	}

	const { name, email, password } = form.data;
	const passwordHash = await hash(password, argonOptions);

	try {
		const user = await prisma.user.create({
			data: {
				name: name,
				email: email,
				password: passwordHash,
			},
		});

		const userResponse: UserResponseDTO = {
			id: user.id,
			name: user.name,
			email: user.email,
		};

		return c.json({ user: userResponse });
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

	const isValidPassword = await verify(user.password, password);
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
	const tokenHashBuffer = await crypto.subtle.digest(
		"SHA-256",
		new TextEncoder().encode(tokenId)
	);
	const tokenHash = Array.from(new Uint8Array(tokenHashBuffer))
		.map((b) => b.toString(16).padStart(2, "0"))
		.join("");

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

	const tokenHashBuffer = await crypto.subtle.digest(
		"SHA-256",
		new TextEncoder().encode(token)
	);
	const tokenHash = Array.from(new Uint8Array(tokenHashBuffer))
		.map((b) => b.toString(16).padStart(2, "0"))
		.join("");

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
