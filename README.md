# Kore Agent Skills

Multi-agent skills for Kore development — UI polish, security audit, performance audit, UX writing, motion design, E2E validation, and basic code simplification.

## Skills Included

| Skill | Purpose |
|---|---|
| `caveman` | Strip code to simplest form |
| `ui-polish` | Visual consistency, accessibility, spacing |
| `ui-ux-pro-max` | Broad UI/UX design intelligence (161 rules, 67 styles) |
| `design-motion-principles` | Purposeful motion/animation (create + audit modes) |
| `ux-writing-skill` | Client-friendly UX copy and microcopy |
| `security-audit` | OWASP Top 10 vulnerability review |
| `performance-audit` | Slow path identification and optimization |
| `e2e-validator` | End-to-end test coverage audit |

## Installation

### Windows (PowerShell)

```powershell
git clone https://github.com/natanmassuia/kore-agent-skills.git
cd kore-agent-skills

# OpenCode
.\scripts\install-opencode.ps1

# Claude Code
.\scripts\install-claude.ps1
```

### Linux / macOS

```bash
git clone https://github.com/natanmassuia/kore-agent-skills.git
cd kore-agent-skills

# Copy to local OpenCode directory
cp -r skills/* ~/.config/opencode/skills/

# Or Claude Code
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
.\scripts\install-opencode.ps1
```

## Security

- Never commit secrets, tokens, or API keys to this repository.
- Never include `.env` files.
- Never include agent chat history or local state.
- Run `.\scripts\validate-skills.ps1` before every commit.
