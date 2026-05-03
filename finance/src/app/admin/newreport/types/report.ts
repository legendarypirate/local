export type ReportType = 'driver' | 'now' | 'later' | 'merchant';

export interface ReportRow {
  dateRange: string;
  name: string;
  deliveredDeliveries: number;
  totalDeliveries: number;
  totalPrice: number;
  salary: number;
  status5Deliveries: number;
  status5MerchantAmount: number;
  status5DriverAmount: number;
  orderCount: number;
}
