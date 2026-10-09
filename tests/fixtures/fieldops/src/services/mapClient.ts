// Client du service de cartographie (géocodage des adresses d'intervention)

const MAP_API_URL = process.env.MAP_API_URL ?? "";
const MAP_API_KEY = process.env.MAP_API_KEY ?? "";

export async function geocodeAddress(address: string): Promise<{ lat: number; lng: number } | null> {
  if (!MAP_API_URL) {
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
