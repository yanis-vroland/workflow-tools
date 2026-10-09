-- Schéma de la base FieldOps (PostgreSQL 15)

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email TEXT NOT NULL UNIQUE,
  display_name TEXT NOT NULL,
  password_hash TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('admin', 'dispatcher', 'technician'))
);

CREATE TABLE technicians (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  skills TEXT[] NOT NULL DEFAULT '{}',
  zone TEXT NOT NULL
);

CREATE TABLE work_orders (
  id SERIAL PRIMARY KEY,
  customer_name TEXT NOT NULL,
  address TEXT NOT NULL,
  description TEXT,
  status TEXT NOT NULL DEFAULT 'open',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE interventions (
  id SERIAL PRIMARY KEY,
  work_order_id INTEGER NOT NULL REFERENCES work_orders(id),
  technician_id INTEGER REFERENCES technicians(id),
  address TEXT NOT NULL,
  lat DOUBLE PRECISION,
  lng DOUBLE PRECISION,
  starts_at TIMESTAMPTZ NOT NULL,
  ends_at TIMESTAMPTZ,
  status TEXT NOT NULL DEFAULT 'planned',
  report TEXT,
  hours NUMERIC(5, 2) NOT NULL DEFAULT 0,
  hourly_rate NUMERIC(8, 2) NOT NULL DEFAULT 0,
  parts_cost NUMERIC(10, 2) NOT NULL DEFAULT 0,
  updated_at TIMESTAMPTZ
);
