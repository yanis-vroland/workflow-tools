import { Router } from "express";
import { query } from "../db";
import { requireAuth, requireRole } from "../middleware/auth";
import { computeInvoice } from "../../domain/invoice";
import { WorkOrder } from "../../domain/types";

export const workOrdersRouter = Router();

workOrdersRouter.use(requireAuth);

workOrdersRouter.get("/", async (_req, res) => {
  res.json(await query<WorkOrder>("SELECT * FROM work_orders ORDER BY created_at DESC"));
});

workOrdersRouter.post("/", requireRole("admin", "dispatcher"), async (req, res) => {
  const { customerName, address, description } = req.body;
  const [workOrder] = await query<WorkOrder>(
    "INSERT INTO work_orders (customer_name, address, description, status) VALUES ($1, $2, $3, 'open') RETURNING *",
    [customerName, address, description],
  );
  res.status(201).json(workOrder);
});

workOrdersRouter.get("/:id/invoice", requireRole("admin"), async (req, res) => {
  const lines = await query<{ hours: number; hourly_rate: number; parts_cost: number }>(
    "SELECT hours, hourly_rate, parts_cost FROM interventions WHERE work_order_id = $1",
    [req.params.id],
  );
  res.json(computeInvoice(lines.map((l) => ({ hours: l.hours, hourlyRate: l.hourly_rate, partsCost: l.parts_cost }))));
});
