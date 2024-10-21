import axios, { isAxiosError } from 'axios';
import { useAuthStore } from './authStore';

const api = axios.create({
	baseURL: import.meta.env.VITE_API_URL
});

api.interceptors.request.use((config) => {
	const session = useAuthStore.getState().session;
	if (session) {
		config.headers.Authorization = `Bearer ${session.id}`;
	}

	return config;
});

api.interceptors.response.use(
	(response) => {
		const newSessionExpiresAt = response.headers['x-new-session-expiresat'];
		if (newSessionExpiresAt) {
			const authStore = useAuthStore.getState();
			if (authStore.session) {
				authStore.session.expiresAt = newSessionExpiresAt;
				useAuthStore.setState({ session: authStore.session });
			}
		}

		return response;
	},
	(error) => {
		if (!isAxiosError(error) || !error.response) {
			return Promise.reject(error);
		}

		if (error.response.status === 401) {
			useAuthStore.setState({ session: null });
			window.location.href = '/login';
		}

		return Promise.reject(error);
	}
);

export default api;
