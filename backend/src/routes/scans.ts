import { Hono } from "hono";
import { authMiddleware } from "../middlewares/auth";
import prisma from "../services/db";
import { deleteFile, uploadFile } from "../services/s3bucket";
import { randomUUID } from "crypto";

const app = new Hono();

app.get("/", authMiddleware, async (c) => {
	const user = c.get("user")!;

	const page = parseInt(c.req.query("page") as string) || 1;
	const limit = parseInt(c.req.query("limit") as string) || 10;

	const validPage = Math.max(1, page);
	const validLimit = Math.min(100, Math.max(1, limit));
	const totalScans = await prisma.scanHistory.count({
		where: { userId: user.id },
	});

	const totalPages = Math.ceil(totalScans / validLimit);
	const offset = (validPage - 1) * validLimit;

	const scans = await prisma.scanHistory.findMany({
		where: { userId: user.id },
		orderBy: { scannedAt: "desc" },
		skip: offset,
		take: validLimit,
	});

	return c.json({
		data: scans,
		pagination: {
			currentPage: validPage,
			totalPages,
			totalScans,
			limit: validLimit,
		},
	});
});

app.post("/", authMiddleware, async (c) => {
	const user = c.get("user")!;
	const { image } = await c.req.parseBody();

	if (!image || !(image instanceof File)) {
		return c.json({ error: "Invalid image" }, 400);
	}

	const scanId = randomUUID();
	const imageUrl = await uploadFile(image, scanId);
	const scan = await prisma.scanHistory.create({
		data: {
			id: scanId,
			imageUrl,
			userId: user.id,
		},
	});

	return c.json({ scan }, 201);
});

app.delete("/:id", authMiddleware, async (c) => {
	const user = c.get("user")!;
	const scanId = c.req.param("id");

	const scan = await prisma.scanHistory.findUnique({
		where: { userId: user.id, id: scanId },
	});

	if (!scan) {
		return c.json({ error: "Scan not found" }, 404);
	}

	await deleteFile(scanId);
	await prisma.scanHistory.delete({
		where: { id: scanId },
	});

	return c.json({ message: "Scan deleted" });
});

export default app;
