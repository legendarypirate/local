/**
 * Geocode address string → { lat, lng } using Google Geocoding API.
 * Set GOOGLE_MAPS_API_KEY (or GOOGLE_GEOCODING_API_KEY) on the delivery server.
 */
async function geocodeAddress(address) {
  const key = process.env.GOOGLE_MAPS_API_KEY || process.env.GOOGLE_GEOCODING_API_KEY;
  if (!key || !address || typeof address !== 'string') return null;

  const q = encodeURIComponent(address.trim());
  const url = `https://maps.googleapis.com/maps/api/geocode/json?address=${q}&region=mn&language=mn&key=${key}`;

  try {
    const res = await fetch(url);
    const data = await res.json();
    if (data.status !== 'OK' || !data.results?.length) return null;
    const loc = data.results[0].geometry?.location;
    if (loc == null || loc.lat == null || loc.lng == null) return null;
    return { lat: Number(loc.lat), lng: Number(loc.lng) };
  } catch (e) {
    console.error('geocodeAddress error:', e);
    return null;
  }
}

module.exports = { geocodeAddress };
