import type { User } from '../types/delivery';

const API_URL = process.env.NEXT_PUBLIC_API_URL || '';

function getAuthHeaders(): Record<string, string> {
  const token = typeof window !== 'undefined' ? localStorage.getItem('token') : null;
  return {
    'Content-Type': 'application/json',
    ...(token ? { Authorization: `Bearer ${token}` } : {}),
  };
}

export async function fetchMerchants(): Promise<User[]> {
  const res = await fetch(`${API_URL}/api/user/merchant`, { headers: getAuthHeaders() });
  const result = await res.json();
  if (result.success && Array.isArray(result.data)) return result.data;
  throw new Error(result.message || 'Failed to fetch merchants');
}

export async function fetchDrivers(): Promise<User[]> {
  const res = await fetch(`${API_URL}/api/user/drivers`, { headers: getAuthHeaders() });
  const result = await res.json();
  if (result.success && Array.isArray(result.data)) return result.data;
  throw new Error(result.message || 'Failed to fetch drivers');
}
