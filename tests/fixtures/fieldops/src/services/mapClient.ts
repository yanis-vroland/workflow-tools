// Client du service de cartographie (géocodage des adresses d'intervention)

const MAP_API_URL = process.env.MAP_API_URL ?? "";
const MAP_API_KEY = process.env.MAP_API_KEY ?? "";
// Date d'expiration de la clé (AAAA-MM-JJ) : la clé se renouvelle à la main auprès du fournisseur
const MAP_API_KEY_EXPIRES_AT = process.env.MAP_API_KEY_EXPIRES_AT ?? "";

export function isMapKeyExpired(now: Date = new Date()): boolean {
  return MAP_API_KEY_EXPIRES_AT !== "" && now >= new Date(MAP_API_KEY_EXPIRES_AT);
}

export async function geocodeAddress(address: string): Promise<{ lat: number; lng: number } | null> {
  if (!MAP_API_URL) {
    return null;
  }
  if (isMapKeyExpired()) {
    console.warn("Clé de cartographie expirée : géocodage désactivé");
    return null;
  }
  const url = `${MAP_API_URL}/geocode?q=${encodeURIComponent(address)}&key=${MAP_API_KEY}`;
  const response = await fetch(url);
  if (!response.ok) {
    return null;
  }
  const body = (await response.json()) as { results: { lat: number; lng: number }[] };
  return body.results[0] ?? null;
}
