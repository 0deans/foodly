import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import { Session } from './types';

export interface AuthStore {
	session: Session | null;
	setSession: (session: Session | null) => void;
	isAuthenticated: () => boolean;
}

export const useAuthStore = create<AuthStore>()(
	persist(
		(set, get) => ({
			session: null,
			setSession: (session) => set({ session }),
			isAuthenticated: () => {
				const { session } = get();
				if (!session) return false;

				const currentTime = new Date().getTime();
				const expiresAt = new Date(session.expiresAt).getTime();

				return currentTime < expiresAt;
			}
		}),
		{ name: 'auth' }
	)
);
