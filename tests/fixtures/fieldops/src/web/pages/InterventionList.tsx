import React, { useEffect, useState } from "react";
import { apiGet } from "../api";
import { Intervention } from "../../domain/types";

const STATUS_LABELS: Record<string, string> = {
  planned: "Planifiée",
  in_progress: "En cours",
  done: "Terminée",
  cancelled: "Annulée",
};

export function InterventionList() {
  const [interventions, setInterventions] = useState<Intervention[]>([]);
  const [status, setStatus] = useState("");

  useEffect(() => {
    apiGet<Intervention[]>(`/interventions${status ? `?status=${status}` : ""}`).then(setInterventions);
  }, [status]);

  return (
    <section>
      <h1>Interventions</h1>
      <select value={status} onChange={(e) => setStatus(e.target.value)}>
        <option value="">Tous les statuts</option>
        {Object.entries(STATUS_LABELS).map(([value, label]) => (
          <option key={value} value={value}>
            {label}
          </option>
        ))}
      </select>
      <ul>
        {interventions.map((intervention) => (
          <li key={intervention.id}>
            <img src="/img/technician.svg" width="48" height="48" />
            <strong>{intervention.address}</strong> — {STATUS_LABELS[intervention.status]}
            <span>{new Date(intervention.starts_at).toLocaleString("fr-FR")}</span>
          </li>
        ))}
      </ul>
    </section>
  );
}
