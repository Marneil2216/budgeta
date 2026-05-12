# Library Discovery — 2026-05-08
## Packages found

### Significant (agents/skills created)
- `supabase_flutter: ^2.5.0` → agent: `.claude/agents/stack/supabase.md`
- `flutter_riverpod: ^2.5.1` + `riverpod_annotation: ^2.3.5` → agent: `.claude/agents/stack/riverpod.md`
- `go_router: ^14.2.7` — covered in flutter.md observations (ShellRoute, guards)
- `flutter_animate: ^4.5.0` — covered in flutter.md observations (animation patterns)
- `intl: ^0.19.0` — used only via CurrencyFormatter wrapper; no dedicated agent needed

### Skills created
- `.claude/skills/stack/riverpod-provider.md` — provider scaffolding patterns
- `.claude/skills/stack/supabase-datasource.md` — datasource CRUD + stream patterns

## Instruction (run during first enrichment only)
For each significant library or framework above not already covered by an agent or skill in
.claude/agents/stack/ or .claude/skills/stack/, create an appropriate focused agent and/or
skill file using the proper Claude Code format (YAML frontmatter + name, description, tools,
model: claude-sonnet-4-5, system prompt + rules).

REQUIRED FORMAT for every agent file:
```
---
name: [agent-name]
description: [one line]
tools: Read, Glob, Grep, Write, Edit, Bash
model: claude-sonnet-4-5
---
You are a [role] specialist...

## Rules
- [rule 1]

## Also Active
<!-- AUTO-ENRICHED-ONCE -->

## Project-Specific Observations
<!-- AUTO-ENRICHED-ONCE -->
```

Focus on: UI frameworks, data access, external API SDKs, domain-specific libraries.
Ignore: standard library, build tools, linters, unused transitive deps.
