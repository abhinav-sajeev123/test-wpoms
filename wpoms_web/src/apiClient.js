import axios from 'axios';

// In development, use VITE_API_BASE_URL if set.
// In production/deployment, dynamically fall back to the same hostname on port 8081.
const API_URL = import.meta.env.VITE_API_BASE_URL || `http://${window.location.hostname}:8081`;

const apiClient = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request Interceptor: Attach JWT Token
apiClient.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('jwtToken');
    if (token) {
      config.headers['Authorization'] = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Response Interceptor: Handle 401 Unauthorized and auto-parse JSON strings
apiClient.interceptors.response.use(
  (response) => {
    if (typeof response.data === 'string') {
      try {
        response.data = JSON.parse(response.data);

      } catch (e) {
        // Ignore if not valid JSON
      }
    }
    return response;
  },
  (error) => {
    if (error.response && typeof error.response.data === 'string') {
      try {
        error.response.data = JSON.parse(error.response.data);
      } catch (e) {}
    }

    if (error.message === 'Network Error' || error.code === 'ERR_NETWORK') {
      // We log this but let it pass to the component
      
    }

    if (error.response && error.response.status === 401) {
      // Clear local storage
      localStorage.removeItem('jwtToken');
      localStorage.removeItem('userId');
      localStorage.removeItem('role');

      // Redirect to login page
      window.location.href = '/login';
    }

    if (error.response?.status === 403) {
      localStorage.removeItem('jwtToken');
      localStorage.removeItem('userId');
      localStorage.removeItem('role');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

export default apiClient;
