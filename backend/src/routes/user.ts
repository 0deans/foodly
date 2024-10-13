import { Hono } from "hono";
import { authMiddleware } from "../middlewares/auth";
import { UserResponseDTO } from "../types";

const app = new Hono();

app.get("/", authMiddleware, async (c) => {
	const user = c.get("user")!;

	const userResponse: UserResponseDTO = {
		id: user.id,
		name: user.name,
		email: user.email,
	};

	return c.json({ user: userResponse });
});

export default app;
