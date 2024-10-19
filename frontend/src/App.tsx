import { createRouter, RouterProvider } from '@tanstack/react-router';
import { routeTree } from './routeTree.gen';
import { useAuthStore } from './lib/authStore';

const router = createRouter({
	routeTree,
	context: { auth: undefined! }
});

declare module '@tanstack/react-router' {
	interface Register {
		router: typeof router;
	}
}

const App = () => {
	const auth = useAuthStore();
	return <RouterProvider router={router} context={{ auth }} />;
};

export default App;
