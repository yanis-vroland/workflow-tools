#!/usr/bin/env node
// wf-audit-web : synthèse d'un rapport Lighthouse (voir ../SKILL.md, mode URL).
//
// Lit sur l'entrée standard le rapport JSON produit par
//   lighthouse '<URL>' --output=json --output-path=stdout --quiet …
// et écrit sur la sortie standard un résumé JSON court, lisible par l'agent :
//   status            "ok" ou "unreachable" (aucune sortie, sortie illisible,
//                     ou erreur d'exécution de Lighthouse : page non chargée)
//   error             cause, si status vaut "unreachable"
//   lighthouseVersion version de Lighthouse
//   fetchTime         heure de la mesure (ISO 8601, UTC)
//   formFactor        profil d'appareil ("mobile" par défaut)
//   requestedUrl      URL demandée
//   finalUrl          URL finalement auditée (après redirection)
//   redirected        true si les deux diffèrent
//   scores            score sur 100 de chaque catégorie (performance,
//                     accessibility, best-practices, seo)
//   issues            audits en échec (score < 0,9) : catégorie, identifiant,
//                     titre, valeur affichée, URL des ressources en cause et
//                     extraits HTML des éléments en cause
//
// Aucun accès réseau, aucune écriture de fichier.

const CATEGORIES = ["performance", "accessibility", "best-practices", "seo"];
const SKIPPED_MODES = new Set(["notApplicable", "manual", "informative", "error"]);
const MAX_ITEMS = 10;

function readStdin() {
  return new Promise((resolve) => {
    let data = "";
    process.stdin.setEncoding("utf8");
    process.stdin.on("data", (chunk) => (data += chunk));
    process.stdin.on("end", () => resolve(data));
    process.stdin.on("error", () => resolve(data));
  });
}

function unreachable(error) {
  return { status: "unreachable", error };
}

function itemUrls(items) {
  const urls = [];
  for (const item of items) {
    for (const candidate of [item?.url, item?.source?.url, item?.request?.url]) {
      if (typeof candidate === "string" && /^https?:\/\//.test(candidate) && !urls.includes(candidate)) {
        urls.push(candidate);
      }
    }
    // Sous-éléments (ex. chaînes de requêtes critiques, éléments groupés)
    if (Array.isArray(item?.subItems?.items)) {
      for (const url of itemUrls(item.subItems.items)) if (!urls.includes(url)) urls.push(url);
    }
  }
  return urls.slice(0, MAX_ITEMS);
}

function itemNodes(items) {
  const nodes = [];
  for (const item of items) {
    const node = item?.node ?? (item?.type === "node" ? item : null);
    const text = node?.snippet ?? node?.selector;
    if (typeof text === "string" && !nodes.includes(text)) nodes.push(text);
  }
  return nodes.slice(0, MAX_ITEMS);
}

function summarize(lhr) {
  if (!lhr || typeof lhr !== "object" || !lhr.categories || !lhr.audits) {
    return unreachable("rapport Lighthouse illisible");
  }
  if (lhr.runtimeError && lhr.runtimeError.code) {
    return unreachable(`${lhr.runtimeError.code}: ${lhr.runtimeError.message ?? ""}`.trim());
  }

  const requestedUrl = lhr.requestedUrl ?? null;
  const finalUrl = lhr.finalDisplayedUrl ?? lhr.mainDocumentUrl ?? lhr.finalUrl ?? requestedUrl;

  const scores = {};
  for (const id of CATEGORIES) {
    const score = lhr.categories[id]?.score;
    scores[id] = typeof score === "number" ? Math.round(score * 100) : null;
  }

  const issues = [];
  const seen = new Set();
  for (const category of CATEGORIES) {
    for (const ref of lhr.categories[category]?.auditRefs ?? []) {
      const audit = lhr.audits[ref.id];
      if (!audit || seen.has(ref.id)) continue;
      if (SKIPPED_MODES.has(audit.scoreDisplayMode)) continue;
      if (typeof audit.score !== "number" || audit.score >= 0.9) continue;
      seen.add(ref.id);
      const items = Array.isArray(audit.details?.items) ? audit.details.items : [];
      issues.push({
        category,
        id: ref.id,
        title: audit.title ?? ref.id,
        score: audit.score,
        displayValue: audit.displayValue ?? null,
        urls: itemUrls(items),
        nodes: itemNodes(items),
      });
    }
  }

  return {
    status: "ok",
    lighthouseVersion: lhr.lighthouseVersion ?? null,
    fetchTime: lhr.fetchTime ?? null,
    formFactor: lhr.configSettings?.formFactor ?? null,
    requestedUrl,
    finalUrl,
    redirected: Boolean(requestedUrl && finalUrl && requestedUrl !== finalUrl),
    scores,
    issues,
  };
}

const input = (await readStdin()).trim();
let result;
if (!input) {
  result = unreachable("aucune sortie de Lighthouse (page non chargée ou Lighthouse en échec)");
} else {
  try {
    result = summarize(JSON.parse(input));
  } catch {
    result = unreachable("sortie de Lighthouse illisible (page non chargée ou Lighthouse en échec)");
  }
}
process.stdout.write(JSON.stringify(result, null, 2) + "\n");
