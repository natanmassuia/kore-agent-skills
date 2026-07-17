---
name: kore-fix
description: Small focused fixes using targeted inspection
---
# KORE FIX
1. Run `node scripts/agent-status.mjs` for clean branch check.
2. Search target error location precisely. NO full scans.
3. Edit minimum blast radius.
4. Validate ONLY with `node scripts/agent-test.mjs <affected_test>`.
5. List changed files with `node scripts/agent-diff-summary.mjs`.
