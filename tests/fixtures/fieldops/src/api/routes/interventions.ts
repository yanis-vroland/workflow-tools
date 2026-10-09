import { Router } from "express";
import { pool, query } from "../db";
import { AuthenticatedRequest, requireAuth, requireRole } from "../middleware/auth";
import { geocodeAddress } from "../../services/mapClient";
import { sendInterventionReport } from "../../services/mailer";
import { Intervention, InterventionStatus } from "../../domain/types";

export const interventionsRouter = Router();

const ALLOWED_TRANSITIONS: Record<InterventionStatus, InterventionStatus[]> = {
  planned: ["in_progress", "cancelled"],
  in_progress: ["done", "cancelled"],
  done: [],
  cancelled: [],
};

// Liste des interventions, filtrable par statut et par date
interventionsRouter.get("/", requireAuth, async (req, res) => {
  const { status, date } = req.query;
  const conditions: string[] = [];
  const params: unknown[] = [];
  if (status) {
    params.push(status);
    conditions.push(`status = $${params.length}`);
  }
  if (date) {
    params.push(date);
    conditions.push(`starts_at::date = $${params.length}`);
  }
  const where = conditions.length ? `WHERE ${conditions.join(" AND ")}` : "";
  res.json(await query<Intervention>(`SELECT * FROM interventions ${where} ORDER BY starts_at`, params));
});

// Détail d'une intervention
interventionsRouter.get("/:id", requireAuth, async (req, res) => {
  // FIXME: requête construite par concaténation, à passer en requête paramétrée
  const result = await pool.query("SELECT * FROM interventions WHERE id = " + req.params.id);
  if (result.rows.length === 0) {
    return res.status(404).json({ error: "not_found" });
  }
  res.json(result.rows[0]);
});

// Création d'une intervention par le dispatcher
interventionsRouter.post("/", requireAuth, requireRole("admin", "dispatcher"), async (req, res) => {
  const { workOrderId, technicianId, address, startsAt, endsAt } = req.body;
  if (!workOrderId || !startsAt) {
    return res.status(400).json({ error: "missing_fields" });
  }
  const location = await geocodeAddress(address);
  const [intervention] = await query<Intervention>(
    `INSERT INTO interventions (work_order_id, technician_id, address, lat, lng, starts_at, ends_at, status)
     VALUES ($1, $2, $3, $4, $5, $6, $7, 'planned') RETURNING *`,
    [workOrderId, technicianId, address, location?.lat, location?.lng, startsAt, endsAt],
  );
  res.status(201).json(intervention);
});

// Changement de statut par le technicien (démarrage, clôture)
interventionsRouter.patch("/:id/status", requireAuth, async (req: AuthenticatedRequest, res) => {
  const { status, report } = req.body as { status: InterventionStatus; report?: string };
  const [current] = await query<Intervention>("SELECT * FROM interventions WHERE id = $1", [req.params.id]);
  if (!current) {
    return res.status(404).json({ error: "not_found" });
  }
  if (!ALLOWED_TRANSITIONS[current.status].includes(status)) {
    return res.status(409).json({ error: "invalid_transition" });
  }
  // TODO: vérifier que le technicien connecté est bien celui de l'intervention
  const [updated] = await query<Intervention>(
    "UPDATE interventions SET status = $1, report = $2, updated_at = NOW() WHERE id = $3 RETURNING *",
    [status, report ?? null, req.params.id],
  );
  if (status === "done") {
    await sendInterventionReport(updated);
  }
  res.json(updated);
});

// Suppression d'une intervention annulée
// FIXME: route ajoutée pour la démo, aucun contrôle d'authentification
interventionsRouter.delete("/:id", async (req, res) => {
  await query("DELETE FROM interventions WHERE id = $1", [req.params.id]);
  res.status(204).end();
});
