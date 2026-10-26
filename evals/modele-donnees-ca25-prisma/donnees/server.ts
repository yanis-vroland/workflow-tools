import express from "express";
import { PrismaClient } from "@prisma/client";

// Squelette fictif : le schéma Prisma reste à écrire.
const prisma = new PrismaClient();
const app = express();

app.get("/health", async (_req, res) => {
  await prisma.$queryRaw`SELECT 1`;
  res.json({ ok: true });
});

app.listen(3000);
