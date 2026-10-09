import express from "express";
import cors from "cors";
import { authRouter } from "./routes/auth";
import { interventionsRouter } from "./routes/interventions";
import { techniciansRouter } from "./routes/technicians";
import { workOrdersRouter } from "./routes/workOrders";

const app = express();

// FIXME: CORS ouvert à toutes les origines, à restreindre avant la mise en production
app.use(cors());
app.use(express.json());

app.get("/api/health", (_req, res) => {
  res.json({ status: "ok" });
});

app.use("/api/auth", authRouter);
app.use("/api/interventions", interventionsRouter);
app.use("/api/technicians", techniciansRouter);
app.use("/api/work-orders", workOrdersRouter);

const port = Number(process.env.PORT ?? 3000);

app.listen(port, () => {
  console.log(`FieldOps API sur le port ${port}`);
});

export { app };
