# Catalog.beer Agent Skills

Teach your AI coding agent (Claude Code, Cursor, GitHub Copilot, Codex, etc.) how to read from and contribute to [Catalog.beer](https://catalog.beer) — an open database of breweries, beers, and brewery locations.

The flagship use case: **you're drinking a beer that isn't in the catalog, and your agent adds it for you** — correctly, without duplicates, and only with facts verified against the brewery's own website.

## What's included

| Skill | What it teaches |
|---|---|
| [`catalog-beer`](./catalog-beer/SKILL.md) | Searching the catalog, adding/updating brewers, beers, and locations via the REST API, the style taxonomy, and the contribution rules that keep the data trustworthy |

## Installation

**Coding agents** (Claude Code, Cursor, Copilot, Codex):

```bash
npx skills add michaelkirkpatrick/catalog-beer-skills
```

Or manually: copy the `catalog-beer/` folder into your agent's skills directory (e.g. `.claude/skills/` for Claude Code, `~/.claude/skills/` for all your projects).

**Claude desktop app / Cowork**: same as above — Cowork picks up skills from your skills folder, or upload the skill via Settings → Capabilities → Skills.

**Claude chat (claude.ai)** — no coding tools needed, but requires a paid plan and a little setup:

1. In Settings → Capabilities, turn on **Code Execution**
2. In the network/domain settings, allow access to `api.catalog.beer` (or all domains)
3. Zip the `catalog-beer/` folder and upload it under Settings → Skills
4. In a conversation, share your API key when Claude asks for it

If you'd rather not install anything, you can also just paste a link to this skill's `SKILL.md` into the chat and ask Claude to follow it.

## You'll need an API key

1. Create a free account at [catalog.beer/signup](https://catalog.beer/signup)
2. Verify your email address
3. Your API key is on your [account page](https://catalog.beer/account)

Free accounts include 1,000 API requests/month. Need more? Email [michael@catalog.beer](mailto:michael@catalog.beer).

## The contribution ethos

Catalog.beer aims to be the freshest, most trustworthy structured beer database on the internet. The skill teaches agents three non-negotiable habits:

1. **No source, no write.** Facts come from the brewery's own website (or the can in your hand) — never from an LLM's memory.
2. **Search before you create.** An entry that already exists gets updated, not duplicated.
3. **When unsure, be less specific.** The style taxonomy supports filing a beer at class, family, or style level — file at the level the evidence supports.

## Links

- [API documentation](https://catalog.beer/api-docs)
- [Catalog.beer](https://catalog.beer)
- This skill is also served directly at [catalog.beer/skills/catalog-beer/SKILL.md](https://catalog.beer/skills/catalog-beer/SKILL.md) — agents can fetch and follow it without installing anything

## License

MIT
