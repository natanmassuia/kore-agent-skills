---
name: caveman
description: Simplify code to its most primitive, readable form — remove unnecessary abstractions, clever patterns, and over-engineering. Trigger with phrases like "caveman this", "simplify this", "make it dumber".
compatibility: opencode, claude, codex
---

# Caveman Skill

## Purpose

Strip code back to its simplest possible form. No magic. No abstractions for their own sake. A junior developer should be able to read it without googling.

## Trigger phrases

- "caveman this"
- "make it dumber"
- "simplify"
- "no abstraction"
- "plain version"

## Rules

- Do not use patterns (factory, strategy, observer, etc.) unless the problem genuinely requires them
- Prefer `if/else` over polymorphism when there are fewer than 4 cases
- Prefer flat code over nested helpers when the helper is called once
- Prefer explicit over DRY when DRY requires an explanation
- Inline functions that are only called once and add no clarity
- Remove unused parameters, options, and configuration knobs
- Use the simplest data structure that works (array before map, map before class)
- No secrets, no tokens, no hardcoded credentials
- No destructive file operations

## Process

1. Read the target code in full
2. Identify every abstraction layer
3. Ask: does this layer earn its complexity?
4. Flatten layers that don't earn their complexity
5. Rename anything whose name requires context to understand
6. Confirm the simplified version passes existing tests or note which tests need updating

## Output

- Produce simplified code inline
- Produce a report at `.dev-reports/caveman-<YYYY-MM-DD>.md` with:
  - What was removed and why
  - Any trade-offs accepted
  - Any tests that may need updating
