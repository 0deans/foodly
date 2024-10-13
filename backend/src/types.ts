import { Session, User } from "@prisma/client";

export type Env = {
	Variables: {
		user: User | null;
		session: Session | null;
	};
};

export interface UserResponseDTO {
	id: string;
	name: string | null;
	email: string;
}

export interface GoogleUser {
	sub: string;
	name: string;
	given_name: string;
	picture: string;
	email: string;
	email_verified: boolean;
}
