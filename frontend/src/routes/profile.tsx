import { Button } from '@/components/ui/button';
import api from '@/lib/api';
import { useAuthStore } from '@/lib/authStore';
import { User } from '@/lib/types';
import { createFileRoute, redirect, useNavigate } from '@tanstack/react-router';

export const Route = createFileRoute('/profile')({
	component: Profile,
	beforeLoad: async ({ location, context }) => {
		if (!context.auth.isAuthenticated()) {
			throw redirect({
				to: '/login',
				search: {
					redirect: location.href
				}
			});
		}
	},
	loader: async () => {
		const res = await api.get<{ user: User }>('/user');
		if (res.status !== 200) throw new Error('Failed to load user');
		return res.data.user;
	}
});

function Profile() {
	const session = useAuthStore((state) => state.session);
	const setSession = useAuthStore((state) => state.setSession);
	const navigate = useNavigate();
	const user = Route.useLoaderData();

	const logout = () => {
		setSession(null);
		navigate({ to: '/' });
	};

	return (
		<main>
			<h1 className="text-3xl text-blue-400">Hello /profile!</h1>
			<Button onClick={logout} variant="destructive">
				Logout
			</Button>
			<pre>Session: {JSON.stringify(session, null, 2)}</pre>
			<pre>User: {JSON.stringify(user, null, 2)}</pre>
		</main>
	);
}
