import { serve } from "@hono/node-server";
import { Prisma, PrismaClient, Session, User } from "@prisma/client";
import { Hono } from "hono";
import { hash, verify } from "@node-rs/argon2";
import { loginSchema, signupSchema } from "./schemas";
import { createMiddleware } from "hono/factory";

type Env = {
	Variables: {
		user: User | null;
		session: Session | null;
	};
};

const app = new Hono<Env>();
const prisma = new PrismaClient();
const SEVEN_DAYS_MS = 1000 * 60 * 60 * 24 * 7;

const authMiddleware = createMiddleware<Env>(async (c, next) => {
	const authHeader = c.req.header("Authorization");
	if (!authHeader || !authHeader.startsWith("Bearer ")) {
		return c.json({ error: "Unauthorized" }, 401);
	}

	const token = authHeader.split(" ")[1];
	const sessionWithUser = await prisma.session.findUnique({
		where: { id: token },
		include: { user: true },
	});

	if (!sessionWithUser) {
		return c.json({ error: "Unauthorized" }, 401);
	}

	if (sessionWithUser.expiresAt < new Date()) {
		await prisma.session.delete({
			where: { id: token },
		});

		return c.json({ error: "Unauthorized" }, 401);
	}

	const activePeriodExpirationDate = new Date(
		sessionWithUser.expiresAt.getTime() - SEVEN_DAYS_MS / 2
	);

	if (activePeriodExpirationDate < new Date()) {
		sessionWithUser.expiresAt = new Date(Date.now() + SEVEN_DAYS_MS);
		await prisma.session.update({
			where: { id: token },
			data: { expiresAt: sessionWithUser.expiresAt },
		});

		c.header(
			"X-New-Session-ExpiresAt",
			sessionWithUser.expiresAt.toISOString()
		);
	}

	const { user, ...sessionWithoutUser } = sessionWithUser;
	c.set("user", user);
	c.set("session", sessionWithoutUser);

	await next();
});

app.get("/", authMiddleware, (c) => {
	const user = c.get("user");
	const session = c.get("session");
	console.log(user, session);

	return c.text("Hello Hono!");
});

app.get("/user", (c) => {
	const users = prisma.user.findMany();
	return c.json({ users });
});

interface UserResponseDTO {
	id: string;
	name: string | null;
	email: string;
}

app.post("/signup", async (c) => {
	const body = await c.req.parseBody();
	const form = signupSchema.safeParse(body);

	if (!form.success) {
		return c.json({ error: form.error.flatten() }, 400);
	}

	const { name, email, password } = form.data;
	const passwordHash = await hash(password, {
		// recommended minimum parameters
		memoryCost: 19456,
		timeCost: 2,
		outputLen: 32,
		parallelism: 1,
	});

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
			expiresAt: new Date(Date.now() + SEVEN_DAYS_MS),
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

app.post("/reset-password/:token", async (c) => {
	const token = c.req.param("token");

	// TODO: Implement me, also create a schema for this
});

const port = 3000;
console.log(`Server is running on port ${port}`);

serve({
	fetch: app.fetch,
	port,
});
