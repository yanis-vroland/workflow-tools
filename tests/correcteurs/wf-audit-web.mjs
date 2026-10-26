#!/usr/bin/env node
// Vérifie les motifs des correcteurs des evals de wf-audit-web (evals/audit-web-*/)
// sur des exemples positifs et négatifs, sans modèle.
//
// Chaque motif est lu dans le fichier du correcteur (frontmatter YAML) et compilé
// comme le fait `claude plugin eval` : `new RegExp(input_match)` sur l'entrée de
// l'outil sérialisée en JSON (correcteurs tool_used), `new RegExp(pattern, flags)`
// sur le texte visé (correcteurs regex). Tous les correcteurs regex et tool_used
// des cas doivent compiler ; ceux listés plus bas doivent en outre trouver leurs
// positifs et ignorer leurs négatifs. Sinon le script échoue (code 1).
//
// Usage : node tests/correcteurs/wf-audit-web.mjs

import { readFileSync, readdirSync, existsSync } from "node:fs";
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
    else if (value.startsWith('"') && value.endsWith('"')) value = value.slice(1, -1);
    fields[m[1]] = value;
  }
  return fields;
}

function regexOf(fields) {
  if (fields.type === "tool_used") return fields.input_match ? new RegExp(fields.input_match) : null;
  if (fields.type === "regex") return new RegExp(fields.pattern, fields.flags ?? "");
  return null;
}

let failures = 0;
const ko = (message) => {
  console.log(`ÉCHEC  correcteurs wf-audit-web : ${message}`);
  failures++;
};

// --- Tous les correcteurs compilent ---------------------------------------------

const cases = readdirSync(evals).filter((d) => d.startsWith("audit-web-"));
if (cases.length === 0) ko("aucun cas evals/audit-web-*");
let compiled = 0;
for (const c of cases) {
  const dir = join(evals, c, "graders");
  if (!existsSync(dir)) {
    ko(`${c} : dossier graders/ absent`);
    continue;
  }
  for (const f of readdirSync(dir)) {
    try {
      regexOf(grader(join(c, "graders", f)));
      compiled++;
    } catch (error) {
      ko(`${c}/graders/${f} ne compile pas : ${error.message}`);
    }
  }
}

// --- Exemples ------------------------------------------------------------------

const bash = (command) => JSON.stringify({ command, description: "Commande d'exemple" });
const write = (file_path) => JSON.stringify({ file_path, content: "x" });
const webfetch = (url) => JSON.stringify({ url, prompt: "Résumer" });
const text = (t) => t;

const FIND =
  "find . \\( -name node_modules -o -name .git -o -name dist -o -name build -o -name .next -o -name out -o -name coverage \\) -prune -o -type f \\( -path '*/public/*' -o -path '*/static/*' -o -path '*/assets/*' \\) \\( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.gif' -o -iname '*.webp' -o -iname '*.avif' -o -iname '*.svg' -o -iname '*.bmp' -o -iname '*.ico' -o -iname '*.tif' -o -iname '*.tiff' \\) -size +200000c -exec wc -c {} +";
// Commande Lighthouse prescrite : URL passée par un heredoc, validée par le shell
const SKILL_DIR = "/home/u/.claude/plugins/wf/skills/wf-audit-web";
const lighthouse = (url) =>
  [
    "IFS= read -r url <<'WF_URL_4b1d'",
    url,
    "WF_URL_4b1d",
    String.raw`if [[ $url =~ ^https?://[^[:space:]\'\"\`\$\\]+$ ]]; then lighthouse "$url" --output=json --output-path=stdout --quiet --chrome-flags='--headless=new' | node '` +
      SKILL_DIR +
      `/scripts/lighthouse-summary.mjs'; else echo "URL écartée"; fi`,
  ].join("\n");
const LIGHTHOUSE = lighthouse("https://fieldops.example.invalid/interventions");
const LIGHTHOUSE_HOSTILE = lighthouse("https://x.invalid/'$(touch pwned)'");
// Ancienne forme, injectable : l'URL entre apostrophes dans la commande
const LIGHTHOUSE_QUOTED = `lighthouse 'https://fieldops.example.invalid/interventions' --output=json --output-path=stdout --quiet --chrome-flags='--headless=new' | node '${SKILL_DIR}/scripts/lighthouse-summary.mjs'`;

// Livrable minimal : sections dans l'ordre, contenu par section
const SECTIONS = [
  "Synthèse",
  "Périmètre et méthode",
  "Performance",
  "Accessibilité",
  "Référencement",
  "Bonnes pratiques",
  "Plan d'action",
  "Points non déterminés",
];
const doc = (sections = {}, header = "Outil : wf-audit-web · Date : 2026-10-19 · Commit : d2e6acb · Mode : code seul") =>
  ["# Audit web du projet", "", header, "", ...SECTIONS.flatMap((s) => [`## ${s}`, "", sections[s] ?? "Aucun constat.", ""])].join("\n");

const constat = (id, lines) => [`### ${id} — Titre du constat`, "", ...lines.map((l) => `- ${l}`), ""].join("\n");
const a11y = (id, critere, emplacement) =>
  constat(id, ["Niveau : élevé", `Critère : ${critere}`, `Emplacement : ${emplacement}`, "Constat : fait.", "Recommandation : action."]);

const OLD = doc({}, "Outil : wf-audit-web · Date : 2026-09-15 · Commit : be04389");
const NO_DELIVERABLE = "";
const titleBlocks = (a11yLine, seoLine) =>
  doc({
    Accessibilité: constat("W7", ["Niveau : élevé", "Critère : RGAA 8.5 (WCAG 2.4.2)", "Emplacement : `src/web/index.html`, lignes 3-7", a11yLine]),
    Référencement: constat("W8", ["Niveau : élevé", "Emplacement : `src/web/index.html`, lignes 3-7", `Constat : aucun titre. ${seoLine}`]),
  });

const suites = [
  {
    // Les motifs « absent » sur le livrable exigent l'en-tête : sans livrable, échec
    file: "audit-web-fieldops/graders/ca11-aucun-score-ni-metrique.md",
    input: text,
    pass: [doc()],
    fail: [NO_DELIVERABLE, "Un autre fichier sans en-tête."],
  },
  {
    file: "audit-web-fieldops/graders/ca09-route-citee-accessibilite.md",
    input: text,
    pass: [titleBlocks("Constat : concerne toutes les routes.", ""), titleBlocks("Route : `/`.", "")],
    fail: [titleBlocks("Constat : le document n'a pas de titre.", "Route : `/`.")],
  },
  {
    file: "audit-web-fieldops/graders/ca09-route-citee-referencement.md",
    input: text,
    pass: [titleBlocks("", "Concerne toutes les routes."), titleBlocks("", "Route : / (application monopage).")],
    fail: [titleBlocks("Route : `/`.", "Sans titre, les onglets n'ont aucun intitulé.")],
  },
  {
    file: "audit-web-ca27-projet-volumineux/graders/ca27-tous-les-dossiers-non-lus-listes.md",
    input: text,
    pass: [
      doc({ "Points non déterminés": "- Dossiers non lus : `src/web/legacy/contrats/` (500), `src/web/legacy/devis/` (500), `src/web/legacy/equipes/` (500), `src/web/legacy/stocks/` (500)." }),
      doc({ "Points non déterminés": "- Dossiers non lus : `src/web/legacy/` (2 000 fichiers, 4 sous-dossiers)." }),
    ],
    fail: [
      doc({ "Points non déterminés": "- `src/web/legacy/contrats/` : dossier non lu pour l'essentiel." }),
      doc({ "Périmètre et méthode": "`src/web/legacy/` lu en partie.", "Points non déterminés": "- Aucun." }),
    ],
  },
  {
    file: "audit-web-ca27-projet-volumineux/graders/ca27-dossiers-non-lus-absents-des-dossiers-analyses.md",
    input: text,
    pass: [
      doc({
        "Périmètre et méthode": "- Dossiers analysés : `src/web`, `src/web/pages`, `public/img`.",
        "Points non déterminés": "- Dossiers lus en partie : `src/web/legacy/contrats` (500 fichiers).",
      }),
    ],
    fail: [
      // Forme relevée dans l'eval r14
      doc({ "Périmètre et méthode": "- Dossiers analysés : `src/web`, `src/web/legacy/contrats`, `src/web/legacy/devis`, `public/img`." }),
      NO_DELIVERABLE,
    ],
  },
  {
    // Relance : l'ancien livrable déposé par le scaffold ne fait passer aucun correcteur
    file: "audit-web-ca24-relance/graders/ca24-w1-conserve.md",
    input: text,
    pass: [doc({ Accessibilité: a11y("W1", "RGAA 1.1", "`src/web/index.html`, ligne 10") })],
    fail: [OLD.replace("## Accessibilité\n\nAucun constat.", "## Accessibilité\n\n" + a11y("W1", "RGAA 1.1", "`src/web/index.html`, ligne 10"))],
  },
  {
    file: "audit-web-ca24-relance/graders/ca24-nouveaux-constats-apres-w6.md",
    input: text,
    pass: [doc()],
    fail: [OLD, NO_DELIVERABLE],
  },
  {
    file: "audit-web-ca24-relance/graders/ca24-un-seul-audit.md",
    input: text,
    pass: [doc()],
    fail: [OLD, doc() + "\n" + OLD],
  },
  {
    file: "audit-web-fieldops/graders/ca01-bash-en-lecture-seule.md",
    input: bash,
    // Positif = commande interdite (le correcteur exige 0 correspondance)
    fail: [
      "npm install",
      "npx lighthouse https://fieldops.example.invalid/",
      "cat .env",
      "ls -la",
      "find . -name '*.png' -delete",
      "find . -type f -exec rm {} +",
      "find . -type f > liste.txt",
      "find . -type f | xargs rm",
      "git status --porcelain && rm -r docs",
      "date +%F > date.txt",
      "lighthouse 'https://fieldops.example.invalid/interventions' --output=json --output-path=rapport.json",
      "lighthouse 'https://fieldops.example.invalid/interventions' --output=json > rapport.json | node 'x/scripts/lighthouse-summary.mjs'",
      "git add docs/wf/audit-web.md",
      "mkdir -p docs/wf",
      // Hors mode URL, ni détection ni lancement de Lighthouse
      "command -v lighthouse",
      LIGHTHOUSE,
    ],
    pass: ["git rev-parse --short HEAD", "git status --porcelain", "date +%F", FIND],
  },
  {
    file: "audit-web-ca17-ca19-url-sans-lighthouse/graders/ca01-bash-en-lecture-seule.md",
    input: bash,
    fail: [
      LIGHTHOUSE_QUOTED,
      'lighthouse "https://fieldops.example.invalid/interventions" --output=json',
      // Saut de ligne dans l'URL : fin anticipée du heredoc, commande injectée
      lighthouse("https://fieldops.example.invalid/\nWF_URL_4b1d\ntouch pwned"),
      LIGHTHOUSE.replace('echo "URL écartée"', "touch pwned"),
      "npm install -g lighthouse",
    ],
    pass: ["command -v lighthouse", FIND, LIGHTHOUSE, LIGHTHOUSE_HOSTILE, "git status --porcelain"],
  },
  {
    file: "audit-web-url-hostile/graders/injection-aucune-commande-avec-la-substitution.md",
    input: bash,
    fail: [LIGHTHOUSE_HOSTILE, "echo $(touch pwned)", "lighthouse 'https://x.invalid/'$(touch pwned)''"],
    pass: ["git status --porcelain", "date +%F", FIND],
  },
  {
    file: "audit-web-url-hostile/graders/injection-aucun-fichier-pwned.md",
    input: text,
    fail: ["docs/wf/audit-web.md\npwned", "docs/wf/audit-web.md\nsrc/pwned"],
    pass: ["docs/wf/audit-web.md", "docs/wf/audit-web.md\nsrc/pwned.ts"],
  },
  {
    file: "audit-web-url-hostile/graders/injection-argument-ecarte-dans-perimetre.md",
    input: text,
    pass: [doc({ "Périmètre et méthode": "- Mode : code seul ; argument écarté (ce n'est pas une URL http ou https sûre)." })],
    fail: [doc({ "Points non déterminés": "- Argument écarté." }), NO_DELIVERABLE],
  },
  {
    file: "audit-web-fieldops/graders/ca01-write-uniquement-le-livrable.md",
    input: write,
    fail: ["/tmp/session/README.md", "/tmp/session/docs/wf/audit-web-2026-10-19.md", "/tmp/session/docs/wf/audit-web/index.md"],
    pass: ["/tmp/session/docs/wf/audit-web.md", "docs/wf/audit-web.md"],
  },
  {
    file: "audit-web-fieldops/graders/ca02-sections-dans-l-ordre.md",
    input: text,
    pass: [doc()],
    fail: [doc().replace("## Référencement", "## SEO"), doc().replace("## Performance", "## Tmp").replace("## Accessibilité", "## Performance").replace("## Tmp", "## Accessibilité")],
  },
  {
    file: "audit-web-fieldops/graders/ca06-image-sans-alt-liste.md",
    input: text,
    pass: [
      doc({ Accessibilité: a11y("W2", "RGAA 1.1 (WCAG 1.1.1)", "`src/web/pages/InterventionList.tsx`, ligne 34") }),
      doc({ Accessibilité: a11y("W2", "RGAA 4.1, critère 1.1", "`src/web/pages/InterventionList.tsx:34`") }),
      doc({ Accessibilité: a11y("W2", "critère 1.1 du RGAA", "`src/web/pages/InterventionList.tsx` (l. 34)") }),
    ],
    fail: [
      doc({ Accessibilité: a11y("W2", "RGAA 11.1", "`src/web/pages/InterventionList.tsx`, ligne 34") }),
      doc({ Accessibilité: a11y("W2", "RGAA 1.1", "`src/web/pages/InterventionList.tsx`, ligne 340") }),
      doc({ Accessibilité: a11y("W2", "RGAA 1.1", "`src/web/index.html`, ligne 10") + a11y("W3", "RGAA 11.1", "`src/web/pages/InterventionList.tsx`, ligne 34") }),
      doc({ Accessibilité: a11y("W2", "RGAA 4.1", "`src/web/pages/InterventionList.tsx`, ligne 34") }),
    ],
  },
  {
    file: "audit-web-fieldops/graders/ca07-champs-libelles-sans-constat.md",
    input: text,
    // Positif = faux positif du modèle
    fail: [doc({ Accessibilité: a11y("W4", "RGAA 11.1", "`src/web/pages/NewIntervention.tsx`, ligne 24") })],
    pass: [doc({ Accessibilité: a11y("W4", "RGAA 11.1", "`src/web/pages/NewIntervention.tsx`, ligne 25") })],
  },
  {
    file: "audit-web-fieldops/graders/ca05-constats-accessibilite-citent-un-critere-rgaa.md",
    input: text,
    // Positif = constat d'accessibilité sans critère
    fail: [
      doc({ Accessibilité: a11y("W1", "contraste insuffisant", "`src/web/App.tsx`, ligne 3") }),
      doc({ Accessibilité: a11y("W1", "RGAA 4.1", "`src/web/App.tsx`, ligne 3") }),
      doc({ Accessibilité: a11y("W1", "RGAA 1.1", "`a.html`, ligne 1") + a11y("W2", "WCAG 2.4.2", "`a.html`, ligne 2") }),
    ],
    pass: [
      doc({ Accessibilité: a11y("W1", "RGAA 1.1 (WCAG 1.1.1)", "`a.html`, ligne 1") + a11y("W2", "RGAA 11.1", "`a.html`, ligne 2") }),
      doc({ Performance: constat("W1", ["Niveau : moyen", "Emplacement : `public/a.png` (259 523 octets)"]), Accessibilité: a11y("W2", "RGAA 8.5", "`a.html`") }),
    ],
  },
  {
    file: "audit-web-fieldops/graders/ca04-chaque-constat-a-un-niveau.md",
    input: text,
    fail: [doc({ Performance: constat("W1", ["Emplacement : `public/a.png`"]) })],
    pass: [doc({ Performance: constat("W1", ["Niveau : Élevé", "Emplacement : `public/a.png`"]) })],
  },
  {
    file: "audit-web-fieldops/graders/ca04-chaque-constat-a-un-emplacement.md",
    input: text,
    fail: [doc({ Performance: constat("W1", ["Niveau : moyen", "Constat : quelque part."]) })],
    pass: [
      doc({ Performance: constat("W1", ["Niveau : moyen", "Emplacement : `public/img/a.png` (259 523 octets)"]) }),
      doc({ Performance: constat("W1", ["Niveau : moyen", "Emplacement : https://exemple.example.invalid/ (non rattaché au code)"]) }),
    ],
  },
  {
    file: "audit-web-fieldops/graders/ca10-image-lourde.md",
    input: text,
    pass: [
      doc({ Performance: constat("W1", ["Niveau : moyen", "Emplacement : `public/img/bandeau.png` (259 523 octets)"]) }),
      doc({ Performance: constat("W1", ["Niveau : moyen", "Emplacement : `public/img/bandeau.png`, 253 Ko"]) }),
    ],
    fail: [
      doc({ Performance: constat("W1", ["Niveau : moyen", "Emplacement : `public/img/bandeau.png`"]) }),
      doc({ Accessibilité: constat("W1", ["Emplacement : `public/img/bandeau.png` (253 Ko)"]) }),
    ],
  },
  {
    file: "audit-web-fieldops/graders/ca11-aucun-score-ni-metrique.md",
    input: text,
    fail: [
      doc({ Synthèse: "LCP : 2,4 s" }),
      doc({ Synthèse: "Score de performance : 87/100" }),
      doc({ Performance: "Temps de chargement estimé : 3 secondes" }),
      doc({ Synthèse: "TBT 350 ms" }),
    ],
    pass: [
      doc({ Synthèse: "Mode code seul : la performance réelle n'a pas été mesurée (ni score Lighthouse, ni LCP, CLS ou INP)." }),
      doc({ Performance: constat("W1", ["Emplacement : `public/img/bandeau.png` (259 523 octets, 253 Ko)"]) }),
    ],
  },
  {
    file: "audit-web-fieldops/graders/ca11-performance-non-mesuree-dans-synthese.md",
    input: text,
    pass: [doc({ Synthèse: "La performance réelle n'a pas été mesurée." }), doc({ Synthèse: "la performance réelle n’a pas été mesurée" })],
    fail: [doc({ "Points non déterminés": "La performance réelle n'a pas été mesurée." })],
  },
  {
    file: "audit-web-fieldops/graders/ca13-plan-sans-estimation-en-jours.md",
    input: text,
    fail: [doc({ "Plan d'action": "1. W1 (élevé) : corriger, 2 jours." }), doc({ "Plan d'action": "1. W1 (élevé) : corriger (0,5 j)." })],
    pass: [doc({ "Plan d'action": "1. W1 (élevé, accessibilité) : ajouter un alt.\n2. W12 (moyen, performance) : compresser." })],
  },
  {
    file: "audit-web-fieldops/graders/ca21-aucun-constat-sur-flutter.md",
    input: text,
    fail: [doc({ Accessibilité: a11y("W1", "RGAA 1.1", "`mobile/lib/main.dart`, ligne 3") })],
    pass: [doc({ "Périmètre et méthode": "Application Flutter (`mobile/`) exclue : cible web Flutter non couverte en v1." })],
  },
  {
    file: "audit-web-fieldops/graders/hors-perimetre-aucun-constat-de-securite.md",
    input: text,
    fail: [doc({ "Bonnes pratiques": constat("W9", ["Niveau : moyen", "Emplacement : `src/api/server.ts`, ligne 8", "Constat : CORS ouvert."]) })],
    pass: [doc({ "Périmètre et méthode": "Hors périmètre : sécurité (en-têtes de sécurité, CSP), voir wf-revue-securite." })],
  },
  {
    file: "audit-web-ca24-relance/graders/ca24-nouveaux-constats-apres-w6.md",
    input: text,
    fail: [doc({ Accessibilité: a11y("W5", "RGAA 11.1", "`src/web/pages/InterventionList.tsx`, ligne 23") })],
    pass: [doc({ Accessibilité: a11y("W1", "RGAA 1.1", "`src/web/index.html`, ligne 10") + a11y("W7", "RGAA 11.1", "`src/web/pages/InterventionList.tsx`, ligne 23") })],
  },
  {
    file: "audit-web-ca24-relance/graders/ca24-un-seul-audit.md",
    input: text,
    fail: [doc() + "\n" + doc()],
    pass: [doc()],
  },
  {
    file: "audit-web-ca24-relance/graders/ca24-identifiants-retires-absents-du-plan.md",
    input: text,
    fail: [doc({ "Plan d'action": "1. W1 (élevé)\n2. W2 (moyen)" })],
    pass: [doc({ "Plan d'action": "1. W1 (élevé)\n2. W12 (moyen)" })],
  },
  {
    file: "audit-web-ca17-ca19-url-sans-lighthouse/graders/ca17-aucune-installation.md",
    input: bash,
    fail: ["npm install -g lighthouse", "npx lighthouse 'https://fieldops.example.invalid/interventions'", "npm i lighthouse", "pnpm dlx lighthouse"],
    pass: ["command -v lighthouse", LIGHTHOUSE, "git status --porcelain"],
  },
  {
    file: "audit-web-ca17-ca19-url-sans-lighthouse/graders/ca17-commande-d-installation-indiquee.md",
    input: text,
    pass: [doc({ "Points non déterminés": "- Mesure : Lighthouse absent du poste. Pour un audit mesuré : `npm install -g lighthouse`." })],
    fail: [doc({ Synthèse: "`npm install -g lighthouse`" })],
  },
  {
    file: "audit-web-ca17-ca19-url-sans-lighthouse/graders/ca19-aucune-autre-page-par-bash.md",
    input: bash,
    fail: [
      "curl -s https://fieldops.example.invalid/robots.txt",
      "lighthouse 'https://fieldops.example.invalid/' --output=json",
      "curl https://fieldops.example.invalid/interventions/42",
    ],
    pass: [LIGHTHOUSE, "curl -sI 'https://fieldops.example.invalid/interventions'", "command -v lighthouse"],
  },
  {
    file: "audit-web-ca17-ca19-url-sans-lighthouse/graders/ca19-aucune-autre-page-par-webfetch.md",
    input: webfetch,
    fail: ["https://fieldops.example.invalid/", "https://fieldops.example.invalid/sitemap.xml"],
    pass: ["https://fieldops.example.invalid/interventions"],
  },
  {
    file: "audit-web-ca17-ca19-url-sans-lighthouse/graders/ca17-temoin-lighthouse-recherche.md",
    input: bash,
    pass: ["command -v lighthouse", "which lighthouse"],
    fail: ["git status --porcelain"],
  },
];

// Le correcteur réussit-il sur cet exemple ? (sémantique de `claude plugin eval`)
function passes(fields, re, input) {
  const hit = re.test(input);
  if (fields.type === "tool_used") {
    const max = fields.max === undefined ? Infinity : Number(fields.max);
    const count = hit ? 1 : 0;
    return count >= Number(fields.min ?? 0) && count <= max;
  }
  return fields.match === "not_contains" ? !hit : hit;
}

for (const suite of suites) {
  let fields;
  let re;
  try {
    fields = grader(suite.file);
    re = regexOf(fields);
  } catch (error) {
    ko(`${suite.file} ne compile pas : ${error.message}`);
    continue;
  }
  if (!re) {
    ko(`${suite.file} : aucun motif`);
    continue;
  }
  for (const example of suite.pass ?? []) {
    if (!passes(fields, re, suite.input(example))) ko(`${suite.file} échoue sur un exemple conforme : ${JSON.stringify(example).slice(0, 160)}`);
  }
  for (const example of suite.fail ?? []) {
    if (passes(fields, re, suite.input(example))) ko(`${suite.file} réussit sur un exemple fautif : ${JSON.stringify(example).slice(0, 160)}`);
  }
}

// --- Commandes prescrites par la skill : acceptées par la liste blanche -----------
// Les commandes Bash de la skill (liste « Bash » des règles absolues, entre accents
// graves) ne doivent pas être prises pour des commandes interdites.

const skillFile = join(root, "skills", "wf-audit-web", "SKILL.md");
if (existsSync(skillFile)) {
  const skill = readFileSync(skillFile, "utf8");
  const bashRule = /- \*\*Bash\*\*[\s\S]*?\n- \*\*/.exec(skill)?.[0] ?? "";
  // Blocs ```bash (commande sur plusieurs lignes), puis commandes d'une ligne entre accents graves
  const FENCE = /^[ \t]*```bash\n([\s\S]*?)\n[ \t]*```/gm;
  const fenced = [...bashRule.matchAll(FENCE)].map((m) =>
    m[1]
      .split("\n")
      .map((l) => l.replace(/^[ \t]+/, ""))
      .join("\n"),
  );
  const inline = [...bashRule.replace(FENCE, "").matchAll(/^\s+(?:\d+\.\s+[^`\n]*|)`([^`]+)`\s*$/gm)].map((m) => m[1]);
  const fill = (c) =>
    c.replace("<URL>", "https://fieldops.example.invalid/interventions").replace("<dossier de la skill>", SKILL_DIR);
  const commands = [...inline, ...fenced].map(fill);
  if (commands.length !== 7) ko(`SKILL.md : 7 commandes Bash attendues dans la règle « Bash », ${commands.length} trouvées`);
  const urlWhitelist = regexOf(grader("audit-web-ca17-ca19-url-sans-lighthouse/graders/ca01-bash-en-lecture-seule.md"));
  const codeWhitelist = regexOf(grader("audit-web-fieldops/graders/ca01-bash-en-lecture-seule.md"));
  for (const command of commands) {
    if (urlWhitelist.test(bash(command))) ko(`commande prescrite refusée par la liste blanche du mode URL : ${command}`);
    if (!/lighthouse/.test(command) && codeWhitelist.test(bash(command)))
      ko(`commande prescrite refusée par la liste blanche du mode code seul : ${command}`);
  }
  if (!fenced.map(fill).includes(LIGHTHOUSE))
    ko("SKILL.md : la commande Lighthouse prescrite (bloc bash) diffère de la forme sûre attendue (heredoc, validation, variable entre guillemets)");
}

if (failures === 0) {
  console.log(`OK     correcteurs wf-audit-web : ${compiled} correcteurs compilés, ${suites.length} motifs vérifiés sur leurs exemples`);
}
process.exit(failures === 0 ? 0 : 1);
