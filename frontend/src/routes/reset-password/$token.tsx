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
import api from '@/lib/api';
import { zodResolver } from '@hookform/resolvers/zod';
import { createFileRoute } from '@tanstack/react-router';
import { isAxiosError } from 'axios';
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
	const [success, setSuccess] = useState(false);

	const onSubmit = form.handleSubmit(async ({ password }) => {
		setSuccess(false);
		api
			.post(`/auth/reset-password/${token}`, { password })
			.then(() => {
				setSuccess(true);
			})
			.catch((error) => {
				if (
					!isAxiosError(error) ||
					!error.response ||
					typeof error.response.data !== 'object' ||
					typeof error.response.data.error !== 'string'
				) {
					form.setError('root', {
						message: 'An error occurred. Please try again later.'
					});
					return;
				}

				form.setError('root', { message: error.response.data.error });
			});
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
					{success && <p className="text-sm font-medium text-green-500">Password updated</p>}
				</form>
			</Form>
		</main>
	);
}
