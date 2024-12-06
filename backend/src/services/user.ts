import { z } from "zod";
import { GoogleUser } from "../types";
import { googleIdTokenSchema } from "../schemas";
import { User } from "@prisma/client";
import prisma from "./db";

export const findOrCreateGoogleUser = async (
	googleUserData: z.infer<typeof googleIdTokenSchema> | GoogleUser
) => {
	const existingAccount = await prisma.connection.findFirst({
		where: {
			provider: "google",
			providerUserId: googleUserData.sub,
		},
		include: { user: true },
	});

	let createdUser: User | null = null;
	if (!existingAccount) {
		createdUser = await prisma.user.create({
			data: {
				avatar: googleUserData.picture,
				email: googleUserData.email,
				name: googleUserData.name,
				Connections: {
					create: {
						provider: "google",
						providerUserId: googleUserData.sub,
					},
				},
			},
		});
	}

	return existingAccount?.user || createdUser;
};
