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
import { useForm } from 'react-hook-form';
import { z } from 'zod';

export const Route = createFileRoute('/login')({
	component: Login
});

const formSchema = z.object({
	email: z.string().email(),
	password: z.string().min(8).max(255)
});

function Login() {
	const form = useForm<z.infer<typeof formSchema>>({
		resolver: zodResolver(formSchema),
		defaultValues: {
			email: '',
			password: ''
		}
	});

	const onSubmit = form.handleSubmit(async (data) => {
		console.log(data);
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
					<Button type="submit">Login</Button>
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
		</main>
	);
}
