import { Hono } from "hono";
import { authMiddleware } from "../middlewares/auth";
import { UserResponseDTO } from "../types";
import { deleteFile, uploadFile } from "../services/s3bucket";
import prisma from "../services/db";

const app = new Hono();

app.get("/", authMiddleware, async (c) => {
	const user = c.get("user")!;

	const userResponse: UserResponseDTO = {
		id: user.id,
		name: user.name,
		avatar: user.avatar,
		email: user.email,
	};

	return c.json({ user: userResponse });
});

app.put("/avatar", authMiddleware, async (c) => {
	const user = c.get("user")!;
	const { avatar } = await c.req.parseBody();

	if (!avatar || !(avatar instanceof File)) {
		return c.json({ error: "Invalid avatar" }, 400);
	}

	if (avatar.size > 1024 * 1024) {
		return c.json({ error: "Avatar size must be less than 1MB" }, 400);
	}

	const avatarUrl = await uploadFile(avatar, user.id);
	await prisma.user.update({
		where: { id: user.id },
		data: { avatar: avatarUrl },
	});

	return c.json({ message: "Avatar updated", avatar: avatarUrl });
});

app.put("/name", authMiddleware, async (c) => {
	const user = c.get("user")!;
	const { name } = await c.req.json();

	if (!name || typeof name !== "string" || name.trim().length === 0) {
		return c.json({ error: "Invalid name" }, 400);
	}

	await prisma.user.update({
		where: { id: user.id },
		data: { name },
	});

	return c.json({ message: "Name updated", name });
});

app.delete("/", authMiddleware, async (c) => {
	const user = c.get("user")!;

	await deleteFile(user.id);
	await prisma.user.delete({
		where: { id: user.id },
	});

	return c.json({ message: "User deleted" });
});

export default app;
