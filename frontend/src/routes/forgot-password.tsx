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
import { createFileRoute, Link } from '@tanstack/react-router';
import { isAxiosError } from 'axios';
import { useState } from 'react';
import { useForm } from 'react-hook-form';
import { z } from 'zod';

export const Route = createFileRoute('/forgot-password')({
	component: ForgotPassword
});

const formSchema = z.object({
	email: z.string().email()
});

function ForgotPassword() {
	const form = useForm<z.infer<typeof formSchema>>({
		resolver: zodResolver(formSchema),
		defaultValues: {
			email: ''
		}
	});
	const [success, setSuccess] = useState(false);

	const onSubmit = form.handleSubmit(async (data) => {
		setSuccess(false);
		api
			.post('/auth/reset-password', data)
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
			<div className="w-max max-w-sm space-y-4">
				<div>
					<h1 className="text-3xl font-semibold">Forgot Your Password?</h1>
					<p className="text-gray-400">
						No worries! Just enter your email and we'll send you a link to reset your password.
					</p>
				</div>
				<Form {...form}>
					<form onSubmit={onSubmit} className="flex w-full max-w-sm flex-col space-y-4">
						<FormField
							control={form.control}
							name="email"
							render={({ field }) => (
								<FormItem>
									<FormLabel>Email</FormLabel>
									<FormControl>
										<Input type="email" {...field} />
									</FormControl>
									<FormMessage />
								</FormItem>
							)}
						/>

						<Button type="submit">Send Password Reset Email</Button>
						{form.formState.errors.root && (
							<p className="text-sm font-medium text-destructive">
								{form.formState.errors.root.message}
							</p>
						)}
						{success && (
							<p className="text-green-500 text-sm font-medium">
								Password reset email sent! Check your inbox.
							</p>
						)}
					</form>
				</Form>
				<p className="text-center text-sm">
					Remember your password?{' '}
					<Link to="/login" className="font-medium underline underline-offset-4">
						Return to login
					</Link>
				</p>
			</div>
		</main>
	);
}
