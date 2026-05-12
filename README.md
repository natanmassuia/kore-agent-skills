# agent-skills

A collection of reusable AI agent skills for software engineering projects. Compatible with Claude Code, OpenCode, and Codex/OpenAI coding agents.

Each skill is a structured prompt file that gives your AI agent a focused set of rules, a checklist, and a defined output format for a specific type of task.

## Skills

| Skill | Trigger phrases | What it does |
|-------|----------------|--------------|
| `caveman` | "caveman this", "simplify", "make it dumber" | Strips code to its simplest readable form — removes unnecessary abstractions, inlines one-off helpers, flattens over-engineered layers |
| `performance-audit` | "performance audit", "why is this slow", "optimize this" | Audits code for bottlenecks (N+1 queries, missing indexes, re-renders, unbounded queries) and produces a prioritized findings report |
| `security-audit` | "security audit", "find vulnerabilities", "review for security" | Reviews code for security issues aligned to OWASP Top 10 — injection, auth gaps, secret handling, input validation, tenant isolation |
| `ui-polish` | "polish the UI", "accessibility check", "fix the styling" | Improves visual consistency, WCAG 2.1 AA accessibility, and responsive behavior without changing component behavior |
| `e2e-validator` | "validate e2e", "e2e review", "check test coverage" | Audits end-to-end tests for missing critical flows, flaky selectors, missing assertions, and poor test isolation |

## How skills work

When you trigger a skill with one of its phrases, the agent loads the skill's rules and follows a defined process:

1. Reads the relevant code
2. Applies a checklist specific to that skill
3. Makes changes (if the skill produces code changes) or produces a report
4. Writes a report to `.dev-reports/` documenting what was found and what was changed

Skills do not modify code outside their scope and never touch secrets, credentials, or environment configuration.

## Installation

Clone this repo, then run the install script for your agent tool, pointing it at your project.

### Claude Code

```powershell
.\install\install-claude.ps1 -TargetProjectPath "C:\Projects\my-project"
```

Copies skills into `.claude/skills/` inside your project.

### OpenCode

```powershell
.\install\install-opencode.ps1 -TargetProjectPath "C:\Projects\my-project"
```

Copies skills into `.opencode/skills/` and updates `opencode.json` with skill permissions.

### Codex / OpenAI coding agents

```powershell
.\install\install-codex.ps1 -TargetProjectPath "C:\Projects\my-project"
```

Copies skills into `.agents/skills/` and creates or updates `AGENTS.md` with a skills block.

---

Install scripts are idempotent — safe to re-run. They overwrite skill files but will not delete unrelated files in your project.

## Updating

```powershell
git pull
.\install\install-claude.ps1 -TargetProjectPath "C:\Projects\my-project"
```

Pull the latest and re-run the install script. New skills are copied automatically.

## Adding skills to this repo

Each skill lives in `skills/<skill-name>/SKILL.md`. The file must start with a frontmatter block:

```markdown
---
name: skill-name
description: One-line description used by the agent to decide when this skill is relevant.
compatibility: opencode, claude, codex
---

# Skill title
...
```

### Rules for skill files

- No secrets, tokens, or credentials
- No hardcoded paths or project-specific values
- No destructive commands (no `rm -rf`, `DROP TABLE`, force-push, etc.)
- Skills should be self-contained — no dependencies on other skills
- Output reports go to `.dev-reports/` with a datestamped filename
