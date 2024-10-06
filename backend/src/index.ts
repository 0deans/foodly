import { serve } from "@hono/node-server";
import { Prisma, PrismaClient } from "@prisma/client";
import { Hono } from "hono";
import { hash } from "@node-rs/argon2";
import { signupSchema } from "./schemas";

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

const port = 3000;
console.log(`Server is running on port ${port}`);

serve({
	fetch: app.fetch,
	port,
});
