/**
 * Хүргэлтийн бүс (Google Maps зураг) — зөвхөн хөгжүүлэлтийн горимд.
 * - `next dev`: автоматаар идэвхтэй (NODE_ENV === 'development')
 * - Production / `next start`: зөвхөн .env дээр NEXT_PUBLIC_DELIVERY_ZONES_DEV=true байвал
 */
export function isDeliveryZonesDevMode(): boolean {
  return (
    process.env.NEXT_PUBLIC_DELIVERY_ZONES_DEV === 'true' ||
    process.env.NODE_ENV === 'development'
  );
}
