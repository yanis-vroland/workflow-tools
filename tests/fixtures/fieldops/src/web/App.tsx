import React, { useState } from "react";
import { InterventionList } from "./pages/InterventionList";
import { NewIntervention } from "./pages/NewIntervention";

export function App() {
  const [page, setPage] = useState<"list" | "new">("list");
  return (
    <main>
      <nav>
        <button onClick={() => setPage("list")}>Interventions</button>
        <button onClick={() => setPage("new")}>Nouvelle intervention</button>
      </nav>
      {page === "list" ? <InterventionList /> : <NewIntervention onCreated={() => setPage("list")} />}
    </main>
  );
}
