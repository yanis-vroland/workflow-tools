---
type: regex
target: { source: file, path: "docs/wf/specs-tickets.md" }
pattern: '^#{2,5} +\**T0[36]\** *:'
flags: m
match: not_contains
---

006-CA16 : les identifiants T03 et T06, supprimés (le dernier identifiant attribué était T06), ne sont jamais réattribués à un ticket.
