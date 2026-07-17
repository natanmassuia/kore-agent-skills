---
name: kore-validate
description: Validation workflow
---
# KORE VALIDATE
- Tier 1 (Edit): Run local affected test.
- Tier 2 (Feature): Run `npm --prefix <module> run typecheck` & build on affected module.
- Tier 3 (Full): NEVER run full suite unless explicitly commanded.
