import { Hono } from "hono";
import { authMiddleware } from "../middlewares/auth";

const app = new Hono();

app.get("/", authMiddleware, async (c) => {
	const user = c.get("user");
	return c.json({ user });
});

export default app;
