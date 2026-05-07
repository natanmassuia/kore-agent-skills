---
name: performance-audit
description: Audit code paths for performance bottlenecks — N+1 queries, redundant renders, blocking I/O, large bundle sizes — and produce a prioritized remediation report. Trigger with phrases like "performance audit", "find slow paths", "optimize this".
compatibility: opencode, claude, codex
---

# Performance Audit Skill

## Purpose

Identify and prioritize performance problems in a given code path, component, or module. Produce actionable findings with estimated impact, not just a list of suggestions.

## Trigger phrases

- "performance audit"
- "find slow paths"
- "why is this slow"
- "optimize this"
- "profile this"

## Rules

- No secrets, no tokens, no hardcoded credentials
- No destructive file operations
- Do not apply fixes automatically unless explicitly asked
- Do not add premature optimizations — flag only real or measurable risks
- Every finding must state: location, problem, severity (critical / high / medium / low), and recommended fix

## Audit checklist

### Database / data layer
- [ ] N+1 query patterns (ORM relations loaded in loops)
- [ ] Missing indexes on frequently filtered or joined columns
- [ ] Unbounded queries (no pagination or limit)
- [ ] Synchronous queries in hot paths that could be batched or cached

### Network / I/O
- [ ] Sequential awaits that could be parallelized
- [ ] Missing caching for repeated identical requests
- [ ] Large payloads returned when only partial data is needed
- [ ] Polling where a subscription or push would be cheaper

### Frontend / rendering
- [ ] Components re-rendering on every parent render without `memo` or stable references
- [ ] Heavy computations inside render that should be memoized
- [ ] Large bundle dependencies (lodash, moment, etc.) imported in full
- [ ] Images or assets without lazy loading or size optimization
- [ ] Layout thrash (reading then writing DOM in a loop)

### Compute
- [ ] O(n²) or worse algorithms where better is available
- [ ] Repeated identical computations that could be cached
- [ ] Synchronous heavy work on the main/UI thread

## Process

1. Identify the code scope from the user's request
2. Read all relevant files
3. Apply the checklist above to each file
4. Rank findings by severity and likely user impact
5. Write the report

## Output

Produce a report at `.dev-reports/performance-audit-<YYYY-MM-DD>.md` with:

- **Executive summary**: top 3 findings
- **Findings table**: location | problem | severity | recommended fix
- **Detailed findings**: one section per finding with code references
- **Quick wins**: changes that are low-effort and high-impact
- **Deferred**: findings that are valid but low priority
