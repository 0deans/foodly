import { createFileRoute } from '@tanstack/react-router';

export const Route = createFileRoute('/')({
	component: Home
});

function Home() {
	return (
		<main className="flex h-full flex-col items-center justify-center">
			<h1 className="text-6xl">🍔 Foodly 🍗</h1>
			<p className="mt-4 text-xl">🚧 Currently in development 🚧</p>
		</main>
	);
}
