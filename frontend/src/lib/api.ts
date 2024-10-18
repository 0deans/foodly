import axios, { isAxiosError } from 'axios';

const api = axios.create({
	baseURL: import.meta.env.VITE_API_URL
});

api.interceptors.request.use((config) => {
	const token = localStorage.getItem('authToken');
	if (token) {
		config.headers.Authorization = `Bearer ${token}`;
	}

	return config;
});

api.interceptors.response.use(
	(response) => response,
	(error) => {
		if (!isAxiosError(error) || !error.response) {
			return Promise.reject(error);
		}

		if (error.response.status === 401) {
			localStorage.removeItem('authToken');
			window.location.href = '/login';
		}

		return Promise.reject(error);
	}
);

export default api;
