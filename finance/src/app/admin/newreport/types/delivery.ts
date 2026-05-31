export interface User {
  id: number;
  username: string;
  phone?: string;
}

export interface PriceSetting {
  id: number;
  label?: string | null;
  merchant_price: number;
  driver_price: number;
  is_default?: boolean;
}

export interface Delivery {
  id: number;
  phone: string;
  address: string;
  status: number | string;
  price: number;
  delivery_price?: number;
  price_setting_id?: number | null;
  price_setting?: PriceSetting | null;
  merchant_report_price?: number;
  driver_report_price?: number;
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
