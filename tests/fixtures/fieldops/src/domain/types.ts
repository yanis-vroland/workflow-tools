// Types métier partagés par l'API et le back-office

export type Role = "admin" | "dispatcher" | "technician";

export type InterventionStatus = "planned" | "in_progress" | "done" | "cancelled";

export interface User {
  id: number;
  email: string;
  displayName: string;
  role: Role;
}

/** Technicien terrain, rattaché à une zone géographique. */
export interface Technician {
  id: number;
  first_name: string;
  last_name: string;
  skills: string[];
  zone: string;
}

/** Ordre de travail : la demande du client, qui peut donner lieu à plusieurs interventions. */
export interface WorkOrder {
  id: number;
  customer_name: string;
  address: string;
  description: string;
  status: "open" | "closed";
  created_at: string;
}

/** Intervention : un passage d'un technicien chez le client, sur un créneau. */
export interface Intervention {
  id: number;
  work_order_id: number;
  technician_id: number | null;
  address: string;
  lat: number | null;
  lng: number | null;
  starts_at: string;
  ends_at: string | null;
  status: InterventionStatus;
  report: string | null;
}
