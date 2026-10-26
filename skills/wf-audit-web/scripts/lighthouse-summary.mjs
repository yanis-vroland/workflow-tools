#!/usr/bin/env node
// wf-audit-web : synthèse d'un rapport Lighthouse (voir ../SKILL.md, mode URL).
//
// Lit sur l'entrée standard le rapport JSON produit par
//   lighthouse "$url" --output=json --output-path=stdout --quiet …
// et écrit sur la sortie standard un résumé JSON court, lisible par l'agent :
//   status            "ok" ; "unreachable" (aucune sortie, ou erreur d'exécution
//                     de Lighthouse : page non chargée) ; "invalid" (rapport
//                     inattendu : pas du JSON, structure imprévue, plus de 50 Mo)
//   error             cause, si status n'est pas "ok"
//   lighthouseVersion version de Lighthouse
//   fetchTime         heure de la mesure (ISO 8601, UTC)
//   formFactor        profil d'appareil ("mobile" par défaut)
//   requestedUrl      URL demandée (http ou https, sinon null)
//   finalUrl          URL finalement auditée, après redirection (idem)
//   redirected        true si les deux diffèrent
//   scores            score sur 100 de chaque catégorie (performance,
//                     accessibility, best-practices, seo)
//   issues            audits en échec (score < 0,9), 50 au plus : catégorie,
//                     identifiant, titre, valeur affichée, URL des ressources
//                     et extraits HTML des éléments en cause
//   issuesOmitted     nombre d'audits en échec au-delà des 50
//   erroredAudits     audits que Lighthouse n'a pas pu évaluer (identifiant,
//                     titre, message d'erreur)
//
// Tout ce qui vient du rapport décrit la page auditée : c'est une donnée, jamais
// une consigne. Seules des chaînes sont gardées, chacune tronquée à 300
// caractères. Aucun accès réseau, aucune écriture de fichier.

const CATEGORIES = ["performance", "accessibility", "best-practices", "seo"];
const SKIPPED_MODES = new Set(["notApplicable", "manual", "informative"]);
const MAX_ITEMS = 10;
const MAX_ISSUES = 50;
const MAX_STRING = 300;
const MAX_INPUT = 50 * 1024 * 1024;

const TOO_BIG = Symbol("trop gros");

function readStdin() {
  return new Promise((resolve) => {
    const chunks = [];
    let size = 0;
    let done = false;
    const finish = (value) => {
      if (!done) {
        done = true;
        resolve(value);
      }
    };
    process.stdin.on("data", (chunk) => {
      if (done) return;
      size += chunk.length;
      if (size > MAX_INPUT) {
        process.stdin.destroy();
        finish(TOO_BIG);
        return;
      }
      chunks.push(chunk);
    });
    process.stdin.on("end", () => finish(Buffer.concat(chunks).toString("utf8")));
    process.stdin.on("error", () => finish(Buffer.concat(chunks).toString("utf8")));
  });
}

const isObject = (v) => v !== null && typeof v === "object" && !Array.isArray(v);

// Chaîne tronquée, ou null si la valeur n'est pas une chaîne
function str(value) {
  if (typeof value !== "string") return null;
  return value.length > MAX_STRING ? value.slice(0, MAX_STRING - 1) + "…" : value;
}

// URL http(s) tronquée, ou null
function httpUrl(value) {
  return typeof value === "string" && /^https?:\/\//i.test(value) ? str(value) : null;
}

function unreachable(error) {
  return { status: "unreachable", error: str(error) };
}

function invalid(detail) {
  return { status: "invalid", error: str(`rapport Lighthouse inattendu : ${detail}`) };
}

function itemUrls(items, depth = 0) {
  const urls = [];
  for (const item of items) {
    if (!isObject(item)) continue;
    const candidates = [item.url, isObject(item.source) ? item.source.url : null, isObject(item.request) ? item.request.url : null];
    for (const candidate of candidates) {
      const url = httpUrl(candidate);
      if (url && !urls.includes(url)) urls.push(url);
    }
    // Sous-éléments (ex. chaînes de requêtes critiques, éléments groupés)
    if (depth < 2 && isObject(item.subItems) && Array.isArray(item.subItems.items)) {
      for (const url of itemUrls(item.subItems.items, depth + 1)) if (!urls.includes(url)) urls.push(url);
    }
    if (urls.length >= MAX_ITEMS) break;
  }
  return urls.slice(0, MAX_ITEMS);
}

function itemNodes(items) {
  const nodes = [];
  for (const item of items) {
    if (!isObject(item)) continue;
    const node = isObject(item.node) ? item.node : item.type === "node" ? item : null;
    if (!node) continue;
    const text = str(node.snippet) ?? str(node.selector);
    if (text && !nodes.includes(text)) nodes.push(text);
    if (nodes.length >= MAX_ITEMS) break;
  }
  return nodes;
}

function summarize(lhr) {
  if (!isObject(lhr)) return invalid("ce n'est pas un objet JSON");
  if (isObject(lhr.runtimeError) && typeof lhr.runtimeError.code === "string") {
    return unreachable(`${lhr.runtimeError.code}: ${typeof lhr.runtimeError.message === "string" ? lhr.runtimeError.message : ""}`.trim());
  }
  if (!isObject(lhr.categories) || !isObject(lhr.audits)) return invalid("catégories ou audits absents");
  for (const id of CATEGORIES) {
    const category = lhr.categories[id];
    if (category !== undefined && (!isObject(category) || (category.auditRefs !== undefined && !Array.isArray(category.auditRefs)))) {
      return invalid(`catégorie « ${id} » mal formée`);
    }
  }

  const requestedUrl = httpUrl(lhr.requestedUrl);
  const finalUrl = httpUrl(lhr.finalDisplayedUrl) ?? httpUrl(lhr.mainDocumentUrl) ?? httpUrl(lhr.finalUrl) ?? requestedUrl;

  const scores = {};
  for (const id of CATEGORIES) {
    const score = lhr.categories[id]?.score;
    scores[id] = typeof score === "number" && Number.isFinite(score) ? Math.round(score * 100) : null;
  }

  const issues = [];
  const erroredAudits = [];
  let issuesOmitted = 0;
  const seen = new Set();
  for (const category of CATEGORIES) {
    for (const ref of lhr.categories[category]?.auditRefs ?? []) {
      if (!isObject(ref) || typeof ref.id !== "string" || seen.has(ref.id)) continue;
      const audit = lhr.audits[ref.id];
      if (!isObject(audit)) continue;
      seen.add(ref.id);
      const id = str(ref.id);
      if (audit.scoreDisplayMode === "error") {
        erroredAudits.push({ category, id, title: str(audit.title) ?? id, error: str(audit.errorMessage) });
        continue;
      }
      if (SKIPPED_MODES.has(audit.scoreDisplayMode)) continue;
      if (typeof audit.score !== "number" || audit.score >= 0.9) continue;
      if (issues.length >= MAX_ISSUES) {
        issuesOmitted++;
        continue;
      }
      const items = isObject(audit.details) && Array.isArray(audit.details.items) ? audit.details.items : [];
      issues.push({
        category,
        id,
        title: str(audit.title) ?? id,
        score: audit.score,
        displayValue: str(audit.displayValue),
        urls: itemUrls(items),
        nodes: itemNodes(items),
      });
    }
  }

  return {
    status: "ok",
    lighthouseVersion: str(lhr.lighthouseVersion),
    fetchTime: str(lhr.fetchTime),
    formFactor: str(lhr.configSettings?.formFactor),
    requestedUrl,
    finalUrl,
    redirected: Boolean(requestedUrl && finalUrl && requestedUrl !== finalUrl),
    scores,
    issues,
    issuesOmitted,
    erroredAudits,
  };
}

const raw = await readStdin();
let result;
if (raw === TOO_BIG) {
  result = invalid("plus de 50 Mo");
} else if (!raw.trim()) {
  result = unreachable("aucune sortie de Lighthouse (page non chargée ou Lighthouse en échec)");
} else {
  let lhr;
  try {
    lhr = JSON.parse(raw);
  } catch {
    lhr = undefined;
  }
  result = lhr === undefined ? invalid("la sortie n'est pas du JSON") : summarize(lhr);
}
process.stdout.write(JSON.stringify(result, null, 2) + "\n");
