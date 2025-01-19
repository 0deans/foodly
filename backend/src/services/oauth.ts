import { Google } from "arctic";
import "dotenv/config";

export const google = new Google(
	process.env.GOOGLE_CLIENT_ID!,
	process.env.GOOGLE_CLIENT_SECRET!,
	`${process.env.BASE_URL}/auth/google/callback`
);
