import { createFileRoute } from '@tanstack/react-router';

export const Route = createFileRoute('/reset-password/$token')({
	component: ResetPassword
});

function ResetPassword() {
	const { token } = Route.useParams();

	return (
		<>
			<div>Hello /reset-password/$token!</div>
			<div className="text-blue-500">Token: {token}</div>
		</>
	);
}
