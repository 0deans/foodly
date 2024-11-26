import { z } from "zod";

export const signupSchema = z.object({
	name: z.string().trim().min(3).max(24).optional(),
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

export const googleIdTokenSchema = z.object({
	iss: z.enum(["accounts.google.com", "https://accounts.google.com"]),
	aud: z.string(),
	sub: z.string(),
	email: z.string().email(),
	email_verified: z.boolean(),
	name: z.string(),
	picture: z.string().url(),
	given_name: z.string(),
	family_name: z.string(),
	iat: z.number(),
	exp: z.number(),
	hd: z.optional(z.string()), // Optional: used for domain verification
});
