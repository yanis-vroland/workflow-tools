import { Router } from "express";
import { query } from "../db";
import { requireAuth, requireRole } from "../middleware/auth";
import { Technician } from "../../domain/types";

export const techniciansRouter = Router();

techniciansRouter.use(requireAuth);

techniciansRouter.get("/", async (_req, res) => {
  const technicians = await query<Technician>("SELECT * FROM technicians ORDER BY last_name");
  res.json(technicians);
});

techniciansRouter.get("/:id/availability", async (req, res) => {
  const slots = await query(
    "SELECT starts_at, ends_at FROM interventions WHERE technician_id = $1 AND starts_at >= NOW()",
    [req.params.id],
  );
  res.json({ technicianId: Number(req.params.id), busy: slots });
});

techniciansRouter.post("/", requireRole("admin"), async (req, res) => {
  const { firstName, lastName, skills, zone } = req.body;
  const [technician] = await query<Technician>(
    "INSERT INTO technicians (first_name, last_name, skills, zone) VALUES ($1, $2, $3, $4) RETURNING *",
    [firstName, lastName, skills, zone],
  );
  res.status(201).json(technician);
});
