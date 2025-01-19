import { Options } from "@node-rs/argon2";

export const SESSION_EXPIRES_IN_MS = 1000 * 60 * 60 * 24 * 7;
export const RESET_PASSWORD_EXPIRES_IN_MS = 1000 * 60 * 15;
export const argonOptions: Options = {
	// recommended minimum parameters
	memoryCost: 19456,
	timeCost: 2,
	outputLen: 32,
	parallelism: 1,
};
