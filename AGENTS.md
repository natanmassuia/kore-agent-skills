# AGENTS.md

## How to install these skills

Read [`agent-install.json`](agent-install.json) for the machine-readable manifest.

### Quick steps

1. Clone or read the `skills/` directory from this repo
2. Copy each skill directory into the target project under `.agents/skills/` (for Codex/Cline/Roo) or `.opencode/skills/` (for OpenCode) or `.claude/skills/` (for Claude Code)
3. For OpenCode: add `"permission": { "skill": { "*": "allow" } }` to `opencode.json`
4. For Codex/Cline/Roo: add the `<!-- KORE_AGENT_SKILLS_START -->...<!-- KORE_AGENT_SKILLS_END -->` block to `AGENTS.md`

### Skill format

Each skill lives in `skills/<name>/SKILL.md` with:
- YAML frontmatter: `name`, `description`, `compatibility`
- Markdown body: `## Purpose`, `## Rules`, `## Process`, `## Output`
