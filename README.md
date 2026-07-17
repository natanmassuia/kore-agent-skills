# Kore Agent Skills

Multi-agent skills for Kore development — code simplification, UI/UX polish, security audit, performance audit, UX writing, motion design, E2E validation, targeted fixes, report generation, and validation workflow.

## Skills Included

| Skill | Purpose |
|---|---|
| `caveman` | Strip code to simplest form |
| `design-motion-principles` | Purposeful motion/animation (create + audit modes) |
| `e2e-validator` | End-to-end test coverage audit |
| `kore-fix` | Small focused fixes using targeted inspection |
| `kore-report` | Report generation (tabular, no prose) |
| `kore-validate` | Validation workflow (tiered testing) |
| `performance-audit` | Slow path identification and optimization |
| `security-audit` | OWASP Top 10 vulnerability review |
| `ui-polish` | Visual consistency, accessibility, spacing |
| `ui-ux-pro-max` | Broad UI/UX design intelligence (161 rules, 67 styles) |
| `ux-writing-skill` | Client-friendly UX copy and microcopy |

## Agent Installation (Automatic)

Any AI coding agent can self-install by parsing [`agent-install.json`](agent-install.json):

```json
{
  "skills_source": "skills/",
  "targets": {
    "opencode": { "paths": [".opencode/skills/", ".agents/skills/"] },
    "claude":    { "paths": [".claude/skills/"] },
    "codex":     { "paths": [".agents/skills/"] }
  }
}
```

Steps an agent should follow:
1. Clone this repo (or read `skills/` directory remotely)
2. Copy each skill directory to the project's target path
3. Apply `config_updates` (e.g., `opencode.json` permissions or `AGENTS.md` block)
4. Run validation

## Manual Installation

### Windows (PowerShell)

```powershell
git clone https://github.com/natanmassuia/kore-agent-skills.git
cd kore-agent-skills

# OpenCode (project-level)
.\install\install-opencode.ps1 -TargetProjectPath "E:\Projects\kore-app"

# Claude Code
.\install\install-claude.ps1

# Codex
.\install\install-codex.ps1
```

### Linux / macOS

```bash
git clone https://github.com/natanmassuia/kore-agent-skills.git
cd kore-agent-skills

# Copy to local OpenCode skills directory
cp -r skills/* ~/.config/opencode/skills/

# Or copy to project-level .opencode/skills
cp -r skills/* /path/to/project/.opencode/skills/

# Or to project-level .agents/skills/
cp -r skills/* /path/to/project/.agents/skills/

# Claude Code
cp -r skills/* ~/.claude/skills/
```

## Validation

```powershell
.\scripts\validate-skills.ps1
```

## Updating

```powershell
cd kore-agent-skills
git pull
.\install\install-opencode.ps1 -TargetProjectPath "E:\Projects\kore-app"
```

## Security

- Never commit secrets, tokens, or API keys to this repository.
- Never include `.env` files.
- Never include agent chat history or local state.
- Run `.\scripts\validate-skills.ps1` before every commit.
