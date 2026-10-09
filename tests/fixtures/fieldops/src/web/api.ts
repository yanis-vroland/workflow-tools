// Appels à l'API depuis le back-office

function authHeaders(): Record<string, string> {
  // TODO: passer le jeton dans un cookie httpOnly plutôt que dans localStorage
  const token = localStorage.getItem("fieldops_token");
  return token ? { Authorization: `Bearer ${token}` } : {};
}

export async function apiGet<T>(path: string): Promise<T> {
  const response = await fetch(`/api${path}`, { headers: authHeaders() });
  if (!response.ok) {
    throw new Error(`GET ${path} : ${response.status}`);
  }
  return response.json();
}

export async function apiPost<T>(path: string, body: unknown): Promise<T> {
  const response = await fetch(`/api${path}`, {
    method: "POST",
    headers: { "Content-Type": "application/json", ...authHeaders() },
    body: JSON.stringify(body),
  });
  if (!response.ok) {
    throw new Error(`POST ${path} : ${response.status}`);
  }
  return response.json();
}
