import { zodResolver } from '@hookform/resolvers/zod';
import { createFileRoute } from '@tanstack/react-router';
import { useState } from 'react';
import { useForm } from 'react-hook-form';
import { z } from 'zod';

export const Route = createFileRoute('/reset-password/$token')({
	component: ResetPassword
});

const formSchema = z
	.object({
		password: z.string().min(8).max(255),
		confirmPassword: z.string().min(8).max(255)
	})
	.superRefine((data, ctx) => {
		if (data.password !== data.confirmPassword) {
			ctx.addIssue({
				code: 'custom',
				message: 'Passwords do not match',
				path: ['confirmPassword']
			});
		}
	});

function ResetPassword() {
	const {
		register,
		handleSubmit,
		setError,
		formState: { errors }
	} = useForm<z.infer<typeof formSchema>>({
		resolver: zodResolver(formSchema)
	});
	const { token } = Route.useParams();
	const [message, setMessage] = useState('');

	const onSubmit = handleSubmit(async ({ password }) => {
		setMessage('');

		const url = new URL(`${import.meta.env.VITE_API_URL}/auth/reset-password/${token}`);
		const formData = new FormData();
		formData.append('password', password);

		const response = await fetch(url.toString(), {
			method: 'POST',
			body: formData
		});

		if (!response.ok) {
			const data = await response.json();
			setError('root', { message: data.error });
			return;
		}

		const data = await response.json();
		setMessage(data.message);
	});

	return (
		<form onSubmit={onSubmit} className="flex max-w-96 flex-col space-y-2">
			<div className="flex flex-col">
				<label htmlFor="password">Password</label>
				<input
					id="password"
					type="text"
					{...register('password')}
					className="rounded-md border border-gray-600 p-2"
				/>
				<p className="text-red-500">{errors.password?.message}</p>
			</div>

			<div className="flex flex-col">
				<label htmlFor="confirmPassword">Confirm Password</label>
				<input
					id="confirmPassword"
					type="text"
					{...register('confirmPassword')}
					className="rounded-md border border-gray-600 p-2"
				/>
				<p className="text-red-500">{errors.confirmPassword?.message}</p>
			</div>

			<button type="submit" className="rounded-md bg-blue-400 p-2 font-medium text-white">
				Submit
			</button>
			<p className="text-red-500">{errors.root?.message}</p>
			<p className="text-green-500">{message}</p>
		</form>
	);
}
