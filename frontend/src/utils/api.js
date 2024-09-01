import axios from 'axios';

const api = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_BASE_URL, // Update with your FastAPI server URL
});

export const fetchBlock = async (blockNumber) => {
  const response = await api.get(`/block/${blockNumber}`);
  return response.data;
};

export const fetchFactor = async (factorId) => {
  const response = await api.get(`/factor/${factorId}`);
  return response.data;
};

export const mineFactor = async (nonce, expression, parentIds) => {
  const response = await api.post(`/mine`, { nonce, expression, parentIds });
  return response.data;
};

export default api;
