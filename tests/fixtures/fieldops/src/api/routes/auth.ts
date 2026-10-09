import { Router } from "express";
import bcrypt from "bcryptjs";
import { query } from "../db";
import { signToken } from "../middleware/auth";
import { User } from "../../domain/types";

export const authRouter = Router();

authRouter.post("/login", async (req, res) => {
  const { email, password } = req.body;
  const [user] = await query<User & { password_hash: string }>(
    "SELECT * FROM users WHERE email = $1",
    [email],
  );
  // TODO: limiter le nombre de tentatives de connexion
  if (!user || !(await bcrypt.compare(password, user.password_hash))) {
    return res.status(401).json({ error: "invalid_credentials" });
  }
  res.json({ token: signToken({ id: user.id, role: user.role }) });
});
