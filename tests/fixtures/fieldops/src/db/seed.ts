import bcrypt from "bcryptjs";
import { pool } from "../api/db";

// Données de démonstration : un compte par rôle, des techniciens et un ordre de travail.
// Le mot de passe commun des comptes de démonstration est lu dans SEED_PASSWORD.

const demoUsers = [
  { email: "admin@example.invalid", displayName: "Admin Démo", role: "admin" },
  { email: "dispatch@example.invalid", displayName: "Dispatcher Démo", role: "dispatcher" },
  { email: "tech1@example.invalid", displayName: "Technicien Démo 1", role: "technician" },
  { email: "tech2@example.invalid", displayName: "Technicien Démo 2", role: "technician" },
];

const demoTechnicians = [
  { firstName: "Technicien", lastName: "Démo 1", skills: ["chauffage", "plomberie"], zone: "nord" },
  { firstName: "Technicien", lastName: "Démo 2", skills: ["électricité"], zone: "sud" },
];

async function seed() {
  const password = process.env.SEED_PASSWORD;
  if (!password) {
    throw new Error("SEED_PASSWORD manquant");
  }
  const hash = await bcrypt.hash(password, 10);
  for (const user of demoUsers) {
    await pool.query(
      "INSERT INTO users (email, display_name, password_hash, role) VALUES ($1, $2, $3, $4) ON CONFLICT DO NOTHING",
      [user.email, user.displayName, hash, user.role],
    );
  }
  for (const technician of demoTechnicians) {
    await pool.query(
      "INSERT INTO technicians (first_name, last_name, skills, zone) VALUES ($1, $2, $3, $4)",
      [technician.firstName, technician.lastName, technician.skills, technician.zone],
    );
  }
  await pool.query(
    "INSERT INTO work_orders (customer_name, address, description) VALUES ($1, $2, $3)",
    ["Client Démo", "1 rue de l'Exemple, 00000 Villefictive", "Entretien annuel de chaudière"],
  );
  await pool.end();
}

seed();
