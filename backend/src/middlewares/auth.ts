import { createMiddleware } from "hono/factory";
import { SESSION_EXPIRES_IN_MS } from "../utils/constants";
import { Env } from "../types";
import prisma from "../services/db";

export const authMiddleware = createMiddleware<Env>(async (c, next) => {
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
		sessionWithUser.expiresAt.getTime() - SESSION_EXPIRES_IN_MS / 2
	);

	if (activePeriodExpirationDate < new Date()) {
		sessionWithUser.expiresAt = new Date(Date.now() + SESSION_EXPIRES_IN_MS);
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
