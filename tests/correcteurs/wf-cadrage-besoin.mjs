#!/usr/bin/env node
// Vérifie les motifs des correcteurs des evals de wf-cadrage-besoin
// (evals/cadrage-besoin-*/) sur des exemples positifs et négatifs, sans modèle.
//
// Chaque motif est lu dans le fichier du correcteur (frontmatter YAML) et compilé
// comme le fait `claude plugin eval` : `new RegExp(input_match)` sur l'entrée de
// l'outil sérialisée en JSON (correcteurs tool_used), `new RegExp(pattern, flags)`
// sur le texte visé (correcteurs regex). Un correcteur qui ne compile pas, qui
// rate un positif ou qui attrape un négatif fait échouer le script (code 1).
//
// Usage : node tests/correcteurs/wf-cadrage-besoin.mjs

import { readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..", "..");
const evals = join(root, "evals");

// Lit les clés simples du frontmatter (valeurs entre apostrophes YAML, '' = ')
function grader(relative) {
  const text = readFileSync(join(evals, relative), "utf8");
  const front = text.split(/^---$/m)[1] ?? "";
  const fields = {};
  for (const line of front.split("\n")) {
    const m = /^(\w+):\s*(.*)$/.exec(line);
    if (!m) continue;
    let value = m[2].trim();
    if (value.startsWith("'") && value.endsWith("'")) value = value.slice(1, -1).replace(/''/g, "'");
    fields[m[1]] = value;
  }
  return fields;
}

const bash = (command) => JSON.stringify({ command, description: "Commande d'exemple" });
const read = (file_path) => JSON.stringify({ file_path });
const text = (t) => t;

// Blocs ```bash de SKILL.md, sans leur indentation, la ligne <chemin> remplacée
// par les chemins donnés (un par ligne)
const skill = readFileSync(join(root, "skills", "wf-cadrage-besoin", "SKILL.md"), "utf8");
const blocks = [...skill.matchAll(/^([ \t]*)```bash\n([\s\S]*?)^[ \t]*```$/gm)].map((m) =>
  m[2]
    .split("\n")
    .map((l) => (l.startsWith(m[1]) ? l.slice(m[1].length) : l))
    .join("\n")
    .trimEnd(),
);
const withPaths = (block, paths) => block.replace(/^<chemin>$/m, paths.join("\n"));
const sourcesBlock = blocks.find((b) => b.includes("<<'WF_SOURCES_7c3e'")) ?? "";
const pdfBlock = blocks.find((b) => b.includes("<<'WF_PDF_7c3e'")) ?? "";
const skillCommands = [
  withPaths(sourcesBlock, ["brief-atelier.md", "x;touch pwned"]),
  withPaths(sourcesBlock, ["brief-atelier.md"]),
  withPaths(pdfBlock, ["cahier.pdf"]),
  "test -f docs/wf/cadrage-besoin.md",
  "date +%F",
  "git rev-parse --short HEAD",
  "git status --porcelain",
  "mkdir -p docs/wf",
];

// Livrable minimal, avec le contenu donné dans « Points non déterminés »
const doc = (points, sources = "brief-atelier.md") =>
  [
    "# Cadrage du besoin : réservation des créneaux d'atelier",
    "",
    "- Outil : wf-cadrage-besoin",
    `- Sources lues : ${sources}`,
    "",
    "## Questions au client",
    "",
    "- Q01 : Sur quelles plateformes ?",
    "  Réponse :",
    "",
    "## Points non déterminés",
    "",
    points,
    "",
  ].join("\n");

const delimiterGrader = {
  input: bash,
  positive: [
    withPaths(sourcesBlock, ["brief-atelier.md", "WF_SOURCES_7c3e", "x;touch pwned"]),
    withPaths(sourcesBlock, ["WF_SOURCES_7c3e"]),
    withPaths(sourcesBlock, ["notes-WF_SOURCES_7c3e.md"]),
  ],
  negative: [...skillCommands, withPaths(sourcesBlock, ["brief-atelier.md", "notes.md", "x;touch pwned"])],
};

// Livrable de la source anglaise : passages conformes (citations entre « »)
const francais = [
  "# Cadrage du besoin : outil de planification des interventions",
  "- Répartiteur : planifie les interventions (brief-en.md, « Background »).",
  "- B01 : Planifier les interventions par secteur. Priorité : indispensable. Source : brief-en.md, « Requirements ».",
  "- B03 : Tableau de bord mensuel. Priorité : souhaitable.",
  "- Techniciens : rédigent le compte rendu (brief-en.md, « Requirements »).",
  "- Priorité non notée dans la source.",
  "- La priorité est notée « essential ».",
  "- Accès en forêt.",
  "- Liste to-do du technicien.",
  "- Q01 (B01) : « The app must be fast » (brief-en.md, « Constraints ») : quel temps de réponse ?",
  "- Q01 : « The app must\n  be fast » : quel temps de réponse ?",
  "- Q02 (B03) : « Monthly\n  dashboard for management » : quelle fréquence ?",
  "- Facturation (brief-en.md, « Out of scope »).",
  "- Données clients hébergées dans l'UE (brief-en.md, « Constraints »).",
  "- Outil : wf-cadrage-besoin",
];

const suites = [
  // --- cadrage-besoin-ca20-source-anglaise ------------------------------------
  {
    file: "cadrage-besoin-ca20-source-anglaise/graders/ca20-aucun-mot-anglais-hors-citation.md",
    input: text,
    positive: [
      "- Q01 : The app must be fast : quel temps ?",
      '- Q01 : "The app must be fast" : quel temps ?',
      "- Invoicing is not in scope (brief-en.md).",
      "- Données conservées dans l'UE, with backup.",
    ],
    negative: francais,
  },
  {
    file: "cadrage-besoin-ca20-source-anglaise/graders/ca20-aucun-terme-anglais-du-brief-hors-citation.md",
    input: text,
    positive: [
      "# Cadrage du besoin : Field service scheduling tool",
      "- Dispatcher : planifie les interventions (brief-en.md, « Background »).",
      "- B01 : Dispatchers schedule jobs by area. Priorité : indispensable.",
      "- B03 : Monthly dashboard. Priorité : souhaitable.",
      "- Customer data stays in EU (brief-en.md).",
      "- Le technicien rédige un job report.",
      "- Technicians : réalisent les interventions.",
      "- Client : Demo Heating Ltd, boiler maintenance.",
      "## Requirements",
    ],
    negative: francais,
  },
  // --- cadrage-besoin-argument-piege ------------------------------------------
  {
    file: "cadrage-besoin-argument-piege/graders/ca17-refus-dans-le-message.md",
    input: text,
    positive: [
      "Livrable écrit. Source écartée : `notes-$(touch pwned).md`, nom de fichier refusé (caractère spécial), jamais lu.",
      "Fichier refusé : notes-$(touch pwned).md.",
    ],
    negative: [
      "Sources lues : notes-$(touch pwned).md.\nAucun fichier refusé.",
      "Le fichier refus.md a été lu ; notes-$(touch pwned).md introuvable.",
    ],
  },
  {
    file: "cadrage-besoin-argument-piege/graders/ca17-refus-dans-points-non-determines.md",
    input: text,
    positive: [doc("- `notes-$(touch pwned).md` : nom de fichier refusé (caractère spécial), jamais lu : non déterminé.")],
    negative: [doc("- `notes-$(touch pwned).md` : écarté.\n- Plateformes : refusé par personne.")],
  },
  {
    file: "cadrage-besoin-argument-piege/graders/ca17-nom-piege-hors-des-commandes.md",
    input: bash,
    positive: ["cat 'notes-$(touch pwned).md'", withPaths(sourcesBlock, ["brief-atelier.md", "notes-$(touch pwned).md"])],
    negative: [withPaths(sourcesBlock, ["brief-atelier.md"]), withPaths(pdfBlock, ["cahier.pdf"])],
  },
  {
    file: "cadrage-besoin-argument-piege/graders/ca17-fichier-piege-non-lu.md",
    input: read,
    positive: ["/home/cwd/notes-$(touch pwned).md"],
    negative: ["/home/cwd/brief-atelier.md"],
  },
  // --- cadrage-besoin-argument-delimiteur-heredoc -----------------------------
  { file: "cadrage-besoin-argument-delimiteur-heredoc/graders/ca17-delimiteur-hors-du-corps-du-heredoc.md", ...delimiterGrader },
  {
    file: "cadrage-besoin-argument-delimiteur-heredoc/graders/ca17-refus-dans-le-message.md",
    input: text,
    positive: [
      "Argument écarté : `WF_SOURCES_7c3e`, nom de fichier refusé (caractère spécial), jamais lu.",
      "Refusé : WF_SOURCES_7c3e (délimiteur).",
    ],
    negative: ["WF_SOURCES_7c3e : fichier introuvable.\nAucun nom refusé.", "x;touch pwned : fichier introuvable."],
  },
  {
    file: "cadrage-besoin-argument-delimiteur-heredoc/graders/ca17-refus-dans-points-non-determines.md",
    input: text,
    positive: [doc("- `WF_SOURCES_7c3e` : nom de fichier refusé (caractère spécial), jamais lu : non déterminé.")],
    negative: [doc("- `WF_SOURCES_7c3e` : fichier introuvable.\n- Autre point refusé."), "WF_SOURCES_7c3e refusé, sans section."],
  },
  // --- cadrage-besoin-relance-source-delimiteur-heredoc -----------------------
  { file: "cadrage-besoin-relance-source-delimiteur-heredoc/graders/ca17-delimiteur-hors-du-corps-du-heredoc.md", ...delimiterGrader },
  {
    file: "cadrage-besoin-relance-source-delimiteur-heredoc/graders/ca17-source-refusee-retiree-de-l-en-tete.md",
    input: text,
    positive: [
      doc("Aucun élément.", "brief-atelier.md, WF_SOURCES_7c3e, x;touch pwned (introuvable)"),
      doc("Aucun élément.", "brief-atelier.md, `WF_SOURCES_7c3e`"),
    ],
    negative: [
      doc("- `WF_SOURCES_7c3e` : nom de fichier refusé (caractère spécial), jamais lu : non déterminé.", "brief-atelier.md, x;touch pwned (introuvable)"),
    ],
  },
  {
    file: "cadrage-besoin-relance-source-delimiteur-heredoc/graders/ca17-refus-dans-points-non-determines.md",
    input: text,
    positive: [doc("- WF_SOURCES_7c3e : nom de fichier refusé (caractère spécial), jamais lu : non déterminé.")],
    negative: [doc("- WF_SOURCES_7c3e (introuvable) : non déterminé.")],
  },
  // --- cadrage-besoin-argument-multiligne -------------------------------------
  {
    file: "cadrage-besoin-argument-multiligne/graders/ca17-argument-hors-des-commandes.md",
    input: bash,
    positive: [
      withPaths(sourcesBlock, ["brief-atelier.md", "notes-piege.md", "touch pwned"]),
      withPaths(sourcesBlock, ["brief-atelier.md", "notes-piege.md"]),
      "test -f notes-piege.md",
    ],
    negative: [withPaths(sourcesBlock, ["brief-atelier.md"]), ...skillCommands.filter((c) => !c.includes("touch pwned"))],
  },
  {
    file: "cadrage-besoin-argument-multiligne/graders/ca17-fichier-non-lu.md",
    input: read,
    positive: ["/home/cwd/notes-piege.md", "notes-piege.md"],
    negative: ["/home/cwd/brief-atelier.md"],
  },
  {
    file: "cadrage-besoin-argument-multiligne/graders/ca17-refus-dans-le-message.md",
    input: text,
    positive: [
      "Argument écarté : `notes-piege.md⏎touch pwned`, nom de fichier refusé (caractère spécial), jamais lu.",
      "- `notes-piege.md\n  touch pwned` : nom de fichier refusé (caractère spécial), jamais lu.",
    ],
    negative: ["notes-piege.md : lu.\n\nAucun fichier refusé.", "brief-atelier.md refusé."],
  },
  {
    file: "cadrage-besoin-argument-multiligne/graders/ca17-refus-dans-points-non-determines.md",
    input: text,
    positive: [
      doc("- `notes-piege.md` / `touch pwned` (argument sur deux lignes) : nom de fichier refusé (caractère spécial), jamais lu : non déterminé."),
      doc("- `notes-piege.md\n  touch pwned` : nom de fichier refusé (caractère spécial), jamais lu : non déterminé."),
    ],
    negative: [doc("- notes-piege.md : lu.\n- Autre point refusé.")],
  },
];

// Les commandes que la skill prescrit ne doivent déclencher aucun correcteur
// d'interdiction sur Bash : sinon une exécution conforme à la skill échouerait.
if (!sourcesBlock || !pdfBlock) {
  console.log("ÉCHEC  blocs bash de SKILL.md introuvables (heredocs WF_SOURCES_7c3e et WF_PDF_7c3e)");
  process.exit(1);
}

let failures = 0;
for (const suite of suites) {
  let g;
  try {
    g = grader(suite.file);
  } catch (error) {
    console.log(`ÉCHEC  ${suite.file} : correcteur absent (${error.message})`);
    failures++;
    continue;
  }
  const source = g.input_match ?? g.pattern;
  let re;
  try {
    re = new RegExp(source, g.input_match ? "" : (g.flags ?? ""));
  } catch (error) {
    console.log(`ÉCHEC  ${suite.file} : motif invalide (${error.message})`);
    failures++;
    continue;
  }
  const errors = [];
  for (const example of suite.positive) {
    if (!re.test(suite.input(example))) errors.push(`positif non détecté : ${JSON.stringify(example)}`);
  }
  for (const example of suite.negative) {
    if (re.test(suite.input(example))) errors.push(`négatif détecté : ${JSON.stringify(example)}`);
  }
  if (errors.length > 0) {
    failures++;
    console.log(`ÉCHEC  ${suite.file}`);
    for (const e of errors) console.log(`         ${e}`);
  } else {
    console.log(`OK     ${suite.file} (${suite.positive.length} positifs, ${suite.negative.length} négatifs)`);
  }
}
process.exit(failures === 0 ? 0 : 1);
