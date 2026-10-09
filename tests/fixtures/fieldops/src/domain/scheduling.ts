import { Intervention, Technician } from "./types";

// Choix du technicien à proposer au dispatcher pour une nouvelle intervention

export interface Slot {
  startsAt: Date;
  endsAt: Date;
}

export function overlaps(a: Slot, b: Slot): boolean {
  return a.startsAt < b.endsAt && b.startsAt < a.endsAt;
}

export function isAvailable(slot: Slot, planned: Intervention[]): boolean {
  return !planned.some((intervention) => {
    if (intervention.status === "cancelled" || !intervention.ends_at) {
      return false;
    }
    return overlaps(slot, { startsAt: new Date(intervention.starts_at), endsAt: new Date(intervention.ends_at) });
  });
}

export function suggestTechnician(
  slot: Slot,
  zone: string,
  requiredSkill: string | null,
  technicians: Technician[],
  plannedByTechnician: Map<number, Intervention[]>,
): Technician | null {
  const candidates = technicians.filter((technician) => {
    if (technician.zone !== zone) {
      return false;
    }
    if (requiredSkill && !technician.skills.includes(requiredSkill)) {
      return false;
    }
    return isAvailable(slot, plannedByTechnician.get(technician.id) ?? []);
  });
  if (candidates.length === 0) {
    return null;
  }
  // HACK: on prend le technicien le moins chargé, sans tenir compte du trajet
  candidates.sort(
    (a, b) => (plannedByTechnician.get(a.id)?.length ?? 0) - (plannedByTechnician.get(b.id)?.length ?? 0),
  );
  return candidates[0];
}
