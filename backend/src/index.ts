import { serve } from "@hono/node-server";
import { Prisma, PrismaClient } from "@prisma/client";
import { Hono } from "hono";
import { hash, verify } from "@node-rs/argon2";
import { loginSchema, signupSchema } from "./schemas";

const app = new Hono();
const prisma = new PrismaClient();

app.get("/", (c) => {
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

	// TODO: Generate Session and return it
});

app.post("/logout", async (c) => {
	// TODO: Destroy Session (use auth middleware)
});

app.post('/reset-password/:token', async (c) => {
	const token = c.req.param('token');

	// TODO: Implement me, also create a schema for this
});



const port = 3000;
console.log(`Server is running on port ${port}`);

serve({
	fetch: app.fetch,
	port,
});
