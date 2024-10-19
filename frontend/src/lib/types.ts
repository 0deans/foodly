export interface Session {
	id: string;
	userId: string;
	expiresAt: string;
}

export interface User {
	id: string;
	name: string | null;
	email: string;
}
