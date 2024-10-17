import { Button } from '@/components/ui/button';
import {
	Form,
	FormControl,
	FormField,
	FormItem,
	FormLabel,
	FormMessage
} from '@/components/ui/form';
import { Input } from '@/components/ui/input';
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
	const form = useForm<z.infer<typeof formSchema>>({
		resolver: zodResolver(formSchema),
		defaultValues: {
			password: '',
			confirmPassword: ''
		}
	});
	const { token } = Route.useParams();
	const [message, setMessage] = useState('');

	const onSubmit = form.handleSubmit(async ({ password }) => {
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
			form.setError('root', { message: data.error });
			return;
		}

		const data = await response.json();
		setMessage(data.message);
	});

	return (
		<main className="flex h-full flex-col items-center justify-center p-12">
			<h1 className="mb-8 text-3xl font-semibold">Reset Password</h1>

			<Form {...form}>
				<form onSubmit={onSubmit} className="flex w-full max-w-sm flex-col space-y-4">
					<FormField
						control={form.control}
						name="password"
						render={({ field }) => (
							<FormItem>
								<FormLabel>Password</FormLabel>
								<FormControl>
									<Input type="password" {...field} />
								</FormControl>
								<FormMessage />
							</FormItem>
						)}
					/>
					<FormField
						control={form.control}
						name="confirmPassword"
						render={({ field }) => (
							<FormItem>
								<FormLabel>Confirm Password</FormLabel>
								<FormControl>
									<Input type="password" {...field} />
								</FormControl>
								<FormMessage />
							</FormItem>
						)}
					/>
					<Button type="submit">Reset Password</Button>
					{form.formState.errors.root && (
						<p className="text-red-500">{form.formState.errors.root.message}</p>
					)}
					<p className="text-green-500">{message}</p>
				</form>
			</Form>
		</main>
	);
}
