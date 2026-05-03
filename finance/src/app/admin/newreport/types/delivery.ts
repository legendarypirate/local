export interface User {
  id: number;
  username: string;
  phone?: string;
}

export interface Delivery {
  id: number;
  phone: string;
  address: string;
  status: number | string;
  price: number;
  comment?: string;
  driver: { username: string } | null;
  createdAt?: string;
  delivered_at?: string;
  status_name?: { status: string; color: string };
  merchant: {
    username: string;
    report_price?: number;
  };
}
