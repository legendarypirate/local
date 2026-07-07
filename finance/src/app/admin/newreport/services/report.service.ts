import type { Delivery } from '../types/delivery';

const API_URL = process.env.NEXT_PUBLIC_API_URL || '';

export interface Order {
  id: number;
  merchant_id: number;
  driver_id: number | null;
  status: number;
  merchant?: { username: string };
  driver?: { username: string };
}

function getAuthHeaders(): Record<string, string> {
  const token = typeof window !== 'undefined' ? localStorage.getItem('token') : null;
  return {
    'Content-Type': 'application/json',
    ...(token ? { Authorization: `Bearer ${token}` } : {}),
  };
}

/** Delivered (3) and «Хаягаар очсон» (status 7 only; not declined status 5) */
export async function fetchReportDeliveries(filters: {
  startDate?: string;
  endDate?: string;
  driverId?: number;
  merchantId?: number;
}): Promise<Delivery[]> {
  if (!API_URL) {
    throw new Error('NEXT_PUBLIC_API_URL is not set');
  }
  let url = `${API_URL}/api/delivery?page=1&limit=10000`;
  if (filters.driverId) url += `&driver_id=${filters.driverId}`;
  if (filters.merchantId) url += `&merchant_id=${filters.merchantId}`;
  if (filters.startDate) url += `&start_date=${filters.startDate}`;
  if (filters.endDate) url += `&end_date=${filters.endDate}`;
  url += `&date_field=delivered_at`;
  url += `&status_ids=3,7`;

  const response = await fetch(url, { headers: getAuthHeaders() });
  if (!response.ok) throw new Error(`HTTP ${response.status}`);
  const result = await response.json();
  if (result.success) return result.data || [];
  throw new Error(result.message || 'Failed to fetch deliveries');
}

export interface MobileReportDay {
  date: string;
  total_deliveries?: string | number;
  delivered_count?: string | number;
  address_visit_count?: string | number;
  delivered_total_price?: string | number;
  for_driver?: string | number;
  driver_margin?: string | number;
}

/** Same source as admin/driver-daily-settlements (Өдрийн тооцоо) */
export async function fetchMobileDriverReport(
  driverId: number,
  startDate: string,
  endDate: string
): Promise<MobileReportDay[]> {
  if (!API_URL) {
    throw new Error('NEXT_PUBLIC_API_URL is not set');
  }
  const url =
    `${API_URL}/api/mobile/delivery/report` +
    `?driver_id=${driverId}&start_date=${startDate}&end_date=${endDate}`;
  const response = await fetch(url, { headers: getAuthHeaders() });
  if (!response.ok) throw new Error(`HTTP ${response.status}`);
  const result = await response.json();
  if (result.success && Array.isArray(result.data)) return result.data;
  throw new Error(result.message || 'Failed to fetch driver report');
}

export async function fetchReportOrders(filters: {
  startDate?: string;
  endDate?: string;
  driverId?: number;
  merchantId?: number;
}): Promise<Order[]> {
  if (!API_URL) {
    throw new Error('NEXT_PUBLIC_API_URL is not set');
  }
  let url = `${API_URL}/api/order?page=1&limit=10000&status_ids=3`;
  if (filters.driverId) url += `&driver_id=${filters.driverId}`;
  if (filters.merchantId) url += `&merchant_id=${filters.merchantId}`;
  if (filters.startDate) url += `&start_date=${filters.startDate}`;
  if (filters.endDate) url += `&end_date=${filters.endDate}`;

  const response = await fetch(url, { headers: getAuthHeaders() });
  if (!response.ok) throw new Error(`HTTP ${response.status}`);
  const result = await response.json();
  if (result.success) return result.data || [];
  throw new Error(result.message || 'Failed to fetch orders');
}
