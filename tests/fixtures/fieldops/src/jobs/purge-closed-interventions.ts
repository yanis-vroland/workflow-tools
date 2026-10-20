import { pool } from "../api/db";

// Purge des interventions clôturées (statut « done ») depuis plus de 24 mois,
// durée de conservation convenue avec le client. Lancée chaque nuit par
// .github/workflows/purge.yml.

const RETENTION_MONTHS = 24;

async function purgeClosedInterventions() {
  const result = await pool.query(
    "DELETE FROM interventions WHERE status = 'done' AND ends_at < NOW() - make_interval(months => $1)",
    [RETENTION_MONTHS],
  );
  console.log(`Purge : ${result.rowCount ?? 0} intervention(s) clôturée(s) supprimée(s)`);
  await pool.end();
}

purgeClosedInterventions();
