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
import { createFileRoute, Link, useRouter } from '@tanstack/react-router';
import { isAxiosError } from 'axios';
import { useForm } from 'react-hook-form';
import { z } from 'zod';

export const Route = createFileRoute('/signup')({
	component: Signup
});

const formSchema = z
	.object({
		email: z.string().email(),
		name: z.union([z.string().trim().min(3).max(24).optional(), z.literal('')]),
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

function Signup() {
	const form = useForm<z.infer<typeof formSchema>>({
		resolver: zodResolver(formSchema),
		defaultValues: {
			email: '',
			name: '',
			password: '',
			confirmPassword: ''
		}
	});
	const router = useRouter();

	const onSubmit = form.handleSubmit(async (data) => {
		if (data.name === '') data.name = undefined;

		api
			.post('/auth/signup', data)
			.then(() => {
				router.history.push('/login');
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
			<h1 className="mb-8 text-3xl font-semibold">Join Foodly🥪</h1>

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
					<FormField
						control={form.control}
						name="name"
						render={({ field }) => (
							<FormItem>
								<FormLabel>
									Name <span className="text-gray-500">(optional)</span>
								</FormLabel>
								<FormControl>
									<Input type="text" {...field} />
								</FormControl>
								<FormMessage />
							</FormItem>
						)}
					/>
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
					<Button type="submit">Sign up</Button>
					{form.formState.errors.root && (
						<p className="text-sm font-medium text-destructive">
							{form.formState.errors.root.message}
						</p>
					)}
				</form>
			</Form>
			<div className="mt-4">
				<p className="text-sm">
					Already have an account?{' '}
					<Link to="/login" className="font-medium underline underline-offset-4">
						Log in
					</Link>
				</p>
			</div>
		</main>
	);
}
