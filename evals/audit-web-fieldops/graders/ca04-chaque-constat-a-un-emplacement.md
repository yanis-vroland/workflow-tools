---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{3,4} [^\n]*\bW\d+\b[^\n]*\n(?!(?:(?!\n#{1,4} )[\s\S])*?(?:(?:[\w-]+/)*[\w.-]+\.(?:html?|tsx?|jsx?|vue|svelte|astro|mjs|cjs|css|png|jpe?g|gif|webp|avif|svg|json)\b|https?://))'
match: not_contains
---

CA4 : chaque constat cite au moins un fichier ou, à défaut, l'URL de la page concernée.
