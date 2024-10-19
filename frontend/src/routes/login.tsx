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
import { useAuthStore } from '@/lib/authStore';
import { Session } from '@/lib/types';
import { zodResolver } from '@hookform/resolvers/zod';
import { createFileRoute, Link, useRouter } from '@tanstack/react-router';
import { isAxiosError } from 'axios';
import { useForm } from 'react-hook-form';
import { z } from 'zod';

export const Route = createFileRoute('/login')({
	component: Login,
	validateSearch: (search: { redirect?: string }) => search
});

const formSchema = z.object({
	email: z.string().email(),
	password: z.string().min(8).max(255)
});

function Login() {
	const setSession = useAuthStore((state) => state.setSession);
	const form = useForm<z.infer<typeof formSchema>>({
		resolver: zodResolver(formSchema),
		defaultValues: {
			email: '',
			password: ''
		}
	});
	const router = useRouter();
	const search = Route.useSearch();

	const onSubmit = form.handleSubmit(async (data) => {
		api
			.post<{ session: Session }>('/auth/login', data)
			.then((response) => {
				setSession(response.data.session);
				router.history.push(search.redirect || '/');
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
			<h1 className="mb-8 text-3xl font-semibold">Login</h1>

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
					<Button type="submit">Log in</Button>
					{form.formState.errors.root && (
						<p className="text-sm font-medium text-destructive">
							{form.formState.errors.root.message}
						</p>
					)}

					<div className="my-8 flex w-full items-center space-x-2">
						<hr className="flex-grow border-t border-gray-400" />
						<span className="text-gray-400">Or continue with</span>
						<hr className="flex-grow border-t border-gray-400" />
					</div>
					<Button variant="outline">
						<img src="/google.svg" alt="Google" className="h-6 w-6" />
						Google
					</Button>
				</form>
			</Form>
			<div className="mt-4">
				<p className="text-sm">
					Don't have an account?{' '}
					<Link to="/signup" className="font-medium underline underline-offset-4">
						Sign up
					</Link>
				</p>
			</div>
		</main>
	);
}
