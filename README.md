# kore-agent-skills

Shared AI agent skills for the Kore codebase. Compatible with OpenCode, Claude Code, and Codex/OpenAI coding agents.

## Skills

| Skill | Description |
|---|---|
| `caveman` | Simplify code to its most primitive, readable form — no cleverness, no abstraction for its own sake |
| `performance-audit` | Audit code paths for performance bottlenecks and produce a prioritized remediation report |
| `security-audit` | Review code for security vulnerabilities aligned to OWASP and Kore security standards |
| `ui-polish` | Refine UI components for consistency, accessibility, and visual quality |

## Security

- No secrets, tokens, or credentials in any skill file
- No hardcoded local paths or environment-specific values
- No destructive commands
- Skills operate within Kore's existing security and permissions model

## Supported Tools

- [OpenCode](https://opencode.ai/docs/skills/)
- [Claude Code](https://docs.claude.com/en/docs/claude-code/skills)
- [Codex / OpenAI coding agents](https://platform.openai.com/docs/codex)

---

## Installation

### OpenCode

```powershell
.\install\install-opencode.ps1 -TargetProjectPath "E:\Projects\kore-app"
```

Copies skills into `.opencode/skills/` and updates `opencode.json` with skill permissions.

### Claude Code

```powershell
.\install\install-claude.ps1 -TargetProjectPath "E:\Projects\kore-app"
```

Copies skills into `.claude/skills/`.

### Codex / OpenAI coding agents

```powershell
.\install\install-codex.ps1 -TargetProjectPath "E:\Projects\kore-app"
```

Copies skills into `.agents/skills/` and creates or updates `AGENTS.md` with a marked block describing available skills.

---

## Updating skills

Pull the latest changes and re-run the install script for your tool. Install scripts are idempotent — they overwrite skill files but will not delete unrelated files.
