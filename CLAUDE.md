# CLAUDE.md

Agent Skills that teach AI coding agents to use the Catalog.beer REST API. The skill lives in `catalog-beer/` (SKILL.md + `references/`).

## The mirror — every change must flow to the frontend

This repo is the canonical source, but the skill is *served* from https://catalog.beer/skills/catalog-beer/SKILL.md (linked from catalog.beer/llms.txt). After ANY change to `catalog-beer/`:

1. Commit + push this repo
2. Run `./sync-to-frontend.sh` (rsyncs into `../catalog-beer/skills/`)
3. Commit the `catalog-beer` frontend repo and deploy it (`./deploy.sh` — Michael runs deploys himself)

Never edit `../catalog-beer/skills/` directly — the sync's `--delete` discards such edits.

## Writing Markdown (every `.md` in this repo)

**Do not hard-wrap prose at 80 characters.** Write each paragraph, list item and frontmatter description as one long line and let the editor soft-wrap it. Hard-wrapped Markdown turns a one-word edit into a six-line diff and means rebalancing lines by hand whenever a clause is added. Every file here was reflowed to this standard on 9 Sep 2026 (1,203 lines became 757 with no content change).

Line breaks are for structure only: between paragraphs, list items, headings and table rows. Inside a code fence, wrap wherever the code wants — fences are never reflowed.

## Versioning

`SKILL.md` frontmatter carries `metadata.version` and `metadata.updated`. `updated` is stamped automatically by `sync-to-frontend.sh` from the last commit touching `catalog-beer/` — never edit it by hand.

`version` is [semver](https://semver.org) and is bumped **by hand**, because the question it answers is a judgement call: *would an agent following the old copy now be wrong?* Zip-installed copies never auto-update, so this number is how someone decides whether to re-download.

- **MAJOR** — the old copy now produces wrong behavior: an auth or endpoint contract changed, a documented field was removed or renamed, a reference file it points at is gone.
- **MINOR** — new ground covered, old copy still correct: a new endpoint, a new reference file, added guidance.
- **PATCH** — same behavior, better wording: clarifications, typos, examples.

## Content rules (learned from live agent testing)

- `references/*.md` must stay faithful to the API docs (`../catalog-beer/api-docs.php`). When the API changes, update both.
- **Never split a constraint across files.** A field shown in a SKILL.md example must carry its documented limits there too (e.g. the `short_description` 160-char cap) — an inline example that omits a constraint substitutes for the reference instead of pointing at it.
- High-cost constraints belong in SKILL.md's "Common mistakes" — testing showed it's the section that most reliably changes agent behavior.
- Keep instructions action-triggered ("read X before your first write to Y"), not blanket ("read everything") — blanket imperatives decay.

## Conventions

- Skill format follows the Agent Skills spec: YAML frontmatter (`name`, `description`, `license`) + markdown body; references loaded on demand.
- Install paths advertised in README: `npx skills add michaelkirkpatrick/catalog-beer-skills`, manual copy, claude.ai zip upload.
