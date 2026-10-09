import { NextFunction, Request, Response } from "express";
import jwt from "jsonwebtoken";
import { Role } from "../../domain/types";

// Valeur de repli pour le développement local
const JWT_SECRET = process.env.JWT_SECRET || "dev-secret";

export interface AuthenticatedRequest extends Request {
  user?: { id: number; role: Role };
}

export function signToken(user: { id: number; role: Role }): string {
  return jwt.sign(user, JWT_SECRET, { expiresIn: "7d" });
}

export function requireAuth(req: AuthenticatedRequest, res: Response, next: NextFunction) {
  const header = req.headers.authorization;
  if (!header?.startsWith("Bearer ")) {
    return res.status(401).json({ error: "unauthorized" });
  }
  try {
    req.user = jwt.verify(header.slice(7), JWT_SECRET) as { id: number; role: Role };
    next();
  } catch {
    res.status(401).json({ error: "invalid_token" });
  }
}

export function requireRole(...roles: Role[]) {
  return (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
    if (!req.user || !roles.includes(req.user.role)) {
      return res.status(403).json({ error: "forbidden" });
    }
    next();
  };
}
