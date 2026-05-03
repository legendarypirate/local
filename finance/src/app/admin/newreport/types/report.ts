import type { Delivery } from './delivery';

export type ReportType = 'driver' | 'now' | 'later' | 'merchant';

export interface ReportRow {
  rowKeyId: string;
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
  /** Төлөв 3 — тайлангийн энэ мөрөнд багтсан хүргэлтүүд */
  deliveredDetails: Delivery[];
  /** Төлөв 7 — хаягаар очсон */
  addressVisitDetails: Delivery[];
}
