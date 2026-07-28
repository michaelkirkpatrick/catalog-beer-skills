# CLAUDE.md

Agent Skills that teach AI coding agents to use the Catalog.beer REST API.
The skill lives in `catalog-beer/` (SKILL.md + `references/`).

## The mirror — every change must flow to the frontend

This repo is the canonical source, but the skill is *served* from
https://catalog.beer/skills/catalog-beer/SKILL.md (linked from
catalog.beer/llms.txt). After ANY change to `catalog-beer/`:

1. Commit + push this repo
2. Run `./sync-to-frontend.sh` (rsyncs into `../catalog-beer/skills/`)
3. Commit the `catalog-beer` frontend repo and deploy it (`./deploy.sh` —
   Michael runs deploys himself)

Never edit `../catalog-beer/skills/` directly — the sync's `--delete`
discards such edits.

## Content rules (learned from live agent testing)

- `references/*.md` must stay faithful to the API docs
  (`../catalog-beer/api-docs.php`). When the API changes, update both.
- **Never split a constraint across files.** A field shown in a SKILL.md
  example must carry its documented limits there too (e.g. the
  `short_description` 160-char cap) — an inline example that omits a
  constraint substitutes for the reference instead of pointing at it.
- High-cost constraints belong in SKILL.md's "Common mistakes" — testing
  showed it's the section that most reliably changes agent behavior.
- Keep instructions action-triggered ("read X before your first write to Y"),
  not blanket ("read everything") — blanket imperatives decay.

## Conventions

- Skill format follows the Agent Skills spec: YAML frontmatter
  (`name`, `description`, `license`) + markdown body; references loaded on
  demand.
- Install paths advertised in README: `npx skills add
  michaelkirkpatrick/catalog-beer-skills`, manual copy, claude.ai zip upload.
