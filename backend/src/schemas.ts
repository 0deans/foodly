import { z } from "zod";

export const signupSchema = z.object({
	name: z.string().trim().optional(),
	email: z.string().email(),
	password: z.string().min(8).max(255),
});

export const loginSchema = z.object({
	email: z.string().email(),
	password: z.string().min(8).max(255),
});

export const resetPasswordRequestSchema = z.object({
	email: z.string().email(),
});

export const resetPasswordSchema = z.object({
	password: z.string().min(8).max(255),
});
