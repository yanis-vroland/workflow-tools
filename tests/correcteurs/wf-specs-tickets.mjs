#!/usr/bin/env node
// Vérifie les motifs des correcteurs des evals de wf-specs-tickets
// (evals/specs-tickets-*/) sur des exemples positifs et négatifs, sans modèle.
//
// Chaque motif est lu dans le fichier du correcteur (frontmatter YAML) et compilé
// comme le fait `claude plugin eval` : `new RegExp(input_match)` sur l'entrée de
// l'outil sérialisée en JSON (correcteurs tool_used), `new RegExp(pattern, flags)`
// sur le texte visé (correcteurs regex). Tous les motifs des cas doivent
// compiler ; un exemple raté ou un négatif attrapé fait échouer le script (code 1).
//
// Usage : node tests/correcteurs/wf-specs-tickets.mjs

import { readdirSync, readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..", "..");
const evals = join(root, "evals");
let fail = 0;

// Lit les clés simples du frontmatter (valeurs entre apostrophes YAML, '' = ')
function fields(path) {
  const text = readFileSync(path, "utf8");
  const front = text.split(/^---$/m)[1] ?? "";
  const out = {};
  for (const line of front.split("\n")) {
    const m = /^(\w+):\s*(.*)$/.exec(line);
    if (!m) continue;
    let value = m[2].trim();
    if (value.startsWith("'") && value.endsWith("'")) value = value.slice(1, -1).replace(/''/g, "'");
    out[m[1]] = value;
  }
  return out;
}

function compile(f) {
  if (f.type === "regex") return new RegExp(f.pattern, f.flags ?? "");
  if (f.type === "tool_used" && f.input_match) return new RegExp(f.input_match);
  return null;
}

// Compilation de tous les motifs
const motifs = {};
for (const c of readdirSync(evals).filter((d) => d.startsWith("specs-tickets-"))) {
  for (const g of readdirSync(join(evals, c, "graders"))) {
    try {
      const re = compile(fields(join(evals, c, "graders", g)));
      if (re) motifs[`${c}/${g.replace(/\.md$/, "")}`] = re;
    } catch (e) {
      console.log(`ÉCHEC  correcteur ${c}/${g} : motif invalide (${e.message})`);
      fail = 1;
    }
  }
}

function check(key, input, expected, label) {
  const re = motifs[key];
  if (!re) {
    console.log(`ÉCHEC  correcteur ${key} introuvable`);
    fail = 1;
    return;
  }
  re.lastIndex = 0;
  const got = re.test(input);
  if (got === expected) {
    console.log(`OK     ${key} : ${label}`);
  } else {
    console.log(`ÉCHEC  ${key} : ${label} (attendu ${expected}, obtenu ${got})`);
    fail = 1;
  }
}

const json = (o) => JSON.stringify(o);
const C01 = "specs-tickets-ca01-cadrage-sans-chiffrage";
const C09 = "specs-tickets-ca09-ca10-avec-chiffrage";
const C14 = "specs-tickets-ca14-projet-avec-code";
const C16 = "specs-tickets-ca16-relance";
const C13 = "specs-tickets-ca13-cycle";
const C22 = "specs-tickets-ca22-fichier-argument";
const CD = "specs-tickets-ca03-modifications-non-commitees";

const doc = (header, extra = "") =>
  `# Tickets : x\n\n${header}\n\n## Synthèse\n\nTexte.\n\n## Ordre de réalisation\n\n1. T01\n\n\`\`\`mermaid\ngraph LR\n  T01 --> T02\n\`\`\`\n\n## Tickets\n\n### T01 : A\n\n#### Récit utilisateur\n\nEn tant que x, je veux y, afin de z.\n\n#### Contexte\n\n#### Critères d'acceptation\n\n- CA1 : Étant donné a, quand b, alors c.\n\n#### Hors périmètre\n\n#### Dépendances\n\n#### Besoins couverts\n\n#### Estimation\n\n#### Fichiers concernés\n\n#### Points à clarifier\n\n### T02 : B\n\n#### Critères d'acceptation\n\n- CA1 : a\n- CA3 : b\n${extra}\n## Besoins non couverts\n\nAucun élément.\n\n## Points non déterminés\n\n- Cycle T01 → T02 → T01 : non déterminé.\n`;
const H = "- Outil : wf-specs-tickets\n- Commit analysé : 2fc99c0\n- Fichiers d'entrée : cadrage-besoin.md, chiffrage.md";
const d = doc(H);

check(`${C01}/ca01-aucun-autre-fichier-cree`, "docs/wf/specs-tickets.md", false, "seul le livrable");
check(`${C01}/ca01-aucun-autre-fichier-cree`, "docs/wf/specs-tickets.md\nnotes.tmp", true, "fichier en plus");
check(`${C01}/ca01-cadrage-non-modifie`, json({ file_path: "/a/docs/wf/cadrage-besoin.md", content: "x" }), true, "cadrage réécrit");
check(`${C01}/ca01-cadrage-non-modifie`, json({ file_path: "/a/docs/wf/specs-tickets.md", content: "cadrage-besoin.md" }), false, "livrable qui cite le cadrage");
check(`${C01}/ca02-sections-dans-l-ordre`, d, true, "cinq sections dans l'ordre");
check(`${C01}/ca02-sections-dans-l-ordre`, d.replace("## Ordre de réalisation", "## Ordre"), false, "section renommée");
check(`${C01}/ca03-aucun-chemin-absolu`, d, false, "aucun chemin absolu");
check(`${C01}/ca03-aucun-chemin-absolu`, "/Users/x/cadrage-besoin.md", true, "chemin absolu");
check(`${C01}/ca04-rubriques-du-premier-ticket`, d, true, "neuf rubriques dans l'ordre");
check(`${C01}/ca04-rubriques-du-premier-ticket`, d.replace("#### Dépendances", "#### Liens"), false, "rubrique manquante");
check(`${C01}/ca06-termes-vagues`, "- CA1 : Étant donné un écran, quand il s'ouvre, alors l'affichage est rapide.", true, "« rapide » sans valeur");
check(`${C01}/ca06-termes-vagues`, "- **CA2** : Étant donné x, quand y, alors la saisie est simple.", true, "« simple » sans valeur");
check(`${C01}/ca06-termes-vagues`, "- CA1 : Étant donné 500 lignes, quand on ouvre, alors l'affichage est rapide (moins de 2 s).", false, "terme avec valeur");
check(`${C01}/ca06-termes-vagues`, "- CA1 : Étant donné x, quand y, alors z s'affiche.", false, "aucun terme");
check(`${C01}/ca09-non-estime`, "C04 (1 à 2 j)", true, "tâche citée sans chiffrage");
check(`${C01}/ca09-non-estime`, "- CA12 : x\nnon estimé", false, "numéro de critère, pas une tâche");
check(`${C01}/ca12-mermaid`, d, true, "schéma dans « Ordre de réalisation »");
check(`${C01}/ca12-mermaid`, d.replace("```mermaid", "```"), false, "pas de schéma");
check(`${C01}/ca17-aucun-outil-de-suivi`, json({ command: "gh issue create --title x" }), true, "gh issue");
check(`${C01}/ca17-aucun-outil-de-suivi`, json({ command: "git rev-parse --short HEAD" }), false, "commande autorisée");

check(`${C09}/ca03-en-tete-cite-chiffrage`, d, true, "chiffrage.md dans l'en-tête");
check(`${C09}/ca03-en-tete-cite-chiffrage`, doc(H.replace(", chiffrage.md", ""), "\nchiffrage.md\n"), false, "chiffrage.md seulement après l'en-tête");
check(`${C09}/ca03-en-tete-nom-seul`, d, false, "noms seuls");
check(`${C09}/ca03-en-tete-nom-seul`, doc(H.replace("cadrage-besoin.md", "docs/wf/cadrage-besoin.md")), true, "chemin docs/wf/ dans l'en-tête");
check(`${C09}/ca09-aucune-tache-inventee`, "C14 (1 à 2 j)", true, "tâche inventée");
check(`${C09}/ca09-aucune-tache-inventee`, "C13, C01, CA14", false, "tâches existantes et critère");

check(`${C14}/ca03-commit-en-tete`, d, true, "commit de la fixture dans l'en-tête");
check(`${C14}/ca03-commit-en-tete`, doc(H.replace("2fc99c0", "921f57c")), false, "commit recopié du cadrage");
check(`${C14}/ca03-commit-en-tete`, doc(H.replace("2fc99c0", "921f57c"), "\n2fc99c0\n"), false, "hash hors de la ligne d'en-tête");
check(`${C14}/ca14-export-pdf-a-creer`, "- `src/domain/pdfExport.ts` (à créer)", false, "fichier marqué à créer");
check(`${C14}/ca14-export-pdf-a-creer`, "- `src/domain/pdfExport.ts`", true, "fichier inexistant non marqué");
check(`${C14}/ca21-env-non-lu`, json({ file_path: "/x/.env" }), true, "Read de .env");
check(`${C14}/ca21-env-non-lu`, json({ file_path: "/x/.env.example" }), false, "Read de .env.example");
check(`${C14}/ca21-env-non-lu-par-bash`, json({ command: "cat .env" }), true, "cat .env");
check(`${C14}/ca21-env-non-lu-par-bash`, json({ command: "date +%F" }), false, "commande autorisée");

check(`${CD}/ca03-commit-et-modifications-non-commitees`, doc(H.replace("2fc99c0", "2fc99c0, modifications non commitées")), true, "mention présente");
check(`${CD}/ca03-commit-et-modifications-non-commitees`, d + "\nmodifications non commitées\n", false, "mention hors de la ligne de commit");

check(`${C16}/ca16-tickets-supprimes-non-reattribues`, d.replace("### T02 : B", "### T03 : B"), true, "T03 réattribué");
check(`${C16}/ca16-tickets-supprimes-non-reattribues`, d.replace("### T02 : B", "### T07 : B"), false, "nouvel identifiant T07");
check(`${C16}/ca16-critere-supprime-non-reattribue`, d.replace("### T01 : A", "### T09 : A").replace("### T02 : B", "### T02 : B\n\n- CA2 : x"), true, "CA2 réattribué dans T02");
check(`${C16}/ca16-critere-supprime-non-reattribue`, d, false, "T02 sans CA2 (CA2 d'un autre ticket ignoré)");
check(`${C16}/ca16-pas-de-doublon-dans-le-fichier`, d + d, true, "livrable dupliqué");
check(`${C16}/ca16-pas-de-doublon-dans-le-fichier`, d, false, "livrable unique");

check(`${C13}/ca13-cycle-dans-points-non-determines`, d, true, "cycle dans « Points non déterminés »");
check(`${C13}/ca13-cycle-dans-points-non-determines`, d.replace("Cycle", "Boucle"), false, "aucun cycle décrit");

check(`${C22}/ca22-aucune-adresse-e-mail`, "écrire à support@example.invalid", true, "adresse e-mail");
check(`${C22}/ca22-aucun-numero-de-telephone`, "appeler le 01 23 45 67 89", true, "téléphone fixe");
check(`${C22}/ca22-aucun-numero-de-telephone`, "+33 6 12 34 56 78", true, "téléphone international");
check(`${C22}/ca22-aucun-numero-de-telephone`, "PDF de 2 Mo, T01-CA1, 2026-10-19", false, "nombres ordinaires");
check(`${C22}/ca22-aucun-nom-de-personne`, "Rédigé par Sophie Renaud", true, "nom de personne");
check(`${C22}/ca22-aucun-nom-de-personne`, "Le responsable d'exploitation", false, "rôle seul");
check(`${C22}/ca03-fichier-d-entree-nom-seul`, "# T\n\n- Fichiers d'entrée : cahier-des-charges-export.md\n\n## Synthèse", true, "nom seul dans l'en-tête");
check(`${C22}/ca03-fichier-d-entree-nom-seul`, "# T\n\n- Fichiers d'entrée : besoins/cahier-des-charges-export.md\n\n## Synthèse\n\ncahier-des-charges-export.md", false, "chemin avec dossier");

console.log(`${Object.keys(motifs).length} motifs compilés`);
process.exit(fail);
