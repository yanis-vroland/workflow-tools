import React, { FormEvent, useState } from "react";
import { apiPost } from "../api";

export function NewIntervention({ onCreated }: { onCreated: () => void }) {
  const [workOrderId, setWorkOrderId] = useState("");
  const [address, setAddress] = useState("");
  const [startsAt, setStartsAt] = useState("");
  const [error, setError] = useState<string | null>(null);

  async function submit(event: FormEvent) {
    event.preventDefault();
    try {
      await apiPost("/interventions", { workOrderId: Number(workOrderId), address, startsAt });
      onCreated();
    } catch {
      setError("Création impossible");
    }
  }

  return (
    <form onSubmit={submit}>
      <h1>Nouvelle intervention</h1>
      <label htmlFor="workOrderId">Ordre de travail</label>
      <input id="workOrderId" value={workOrderId} onChange={(e) => setWorkOrderId(e.target.value)} />
      <input placeholder="Adresse" value={address} onChange={(e) => setAddress(e.target.value)} />
      <label htmlFor="startsAt">Début</label>
      <input id="startsAt" type="datetime-local" value={startsAt} onChange={(e) => setStartsAt(e.target.value)} />
      {error && <p className="error">{error}</p>}
      <button type="submit">Créer</button>
    </form>
  );
}
