import type { Delivery } from '../types/delivery';
import type { ReportType } from '../types/report';

export const FALLBACK_MERCHANT_UNIT = 6000;
export const FALLBACK_DRIVER_UNIT = 4000;

export function merchantUnit(d: Delivery): number {
  const ps = d.price_setting;
  if (ps?.merchant_price != null) return Number(ps.merchant_price);
  if (d.merchant_report_price != null) return Number(d.merchant_report_price);
  return Number(d.delivery_price ?? FALLBACK_MERCHANT_UNIT);
}

export function driverUnit(d: Delivery): number {
  const ps = d.price_setting;
  if (ps?.driver_price != null) return Number(ps.driver_price);
  if (d.driver_report_price != null) return Number(d.driver_report_price);
  return FALLBACK_DRIVER_UNIT;
}

export function sumMerchantUnits(list: Delivery[]): number {
  return list.reduce((sum, d) => sum + merchantUnit(d), 0);
}

export function sumDriverUnits(list: Delivery[]): number {
  return list.reduce((sum, d) => sum + driverUnit(d), 0);
}

export function unitForOrderType(
  type: ReportType | 'now',
  isCustomer: boolean,
  defaults: { merchant: number; driver: number }
): number {
  const t = isCustomer ? 'now' : type;
  return t === 'driver' ? defaults.driver : defaults.merchant;
}

export function salaryForDeliveries(
  list: Delivery[],
  reportType: ReportType | 'now',
  isCustomer: boolean
): number {
  const t = isCustomer ? 'now' : reportType;
  return t === 'driver' ? sumDriverUnits(list) : sumMerchantUnits(list);
}
