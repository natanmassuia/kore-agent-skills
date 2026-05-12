---
name: e2e-validator
description: Audit end-to-end test coverage and quality — missing critical flows, flaky selectors, missing assertions, poor test isolation. Trigger with phrases like "validate e2e", "e2e review", "check test coverage", "are the e2e tests good".
compatibility: opencode, claude, codex
---

# E2E Validator Skill

## Purpose

Review existing end-to-end tests for coverage gaps, reliability issues, and maintainability problems. Produce a prioritized report with findings and recommended additions. Do not delete or rewrite tests without explicit instruction.

## Trigger phrases

- "validate e2e"
- "e2e review"
- "check e2e coverage"
- "are the e2e tests good"
- "review test coverage"
- "what flows are untested"

## Rules

- No secrets, no tokens, no hardcoded credentials
- No destructive file operations
- Do not delete or rewrite existing tests unless explicitly asked
- Do not run tests — audit only, unless explicitly asked to run
- Do not add tests that depend on external services without mocking or noting the dependency
- Flag any test that touches production data or external APIs without isolation

## Audit checklist

### Coverage — critical flows
- [ ] Authentication flows: login, logout, session expiry, password reset
- [ ] Authorization flows: role-based access, permission boundaries, unauthorized access attempts
- [ ] Core CRUD operations for primary entities
- [ ] Error flows: invalid input, server errors, network failures
- [ ] Edge cases: empty states, large data sets, concurrent actions

### Selector quality
- [ ] Selectors use `data-testid` or semantic roles — not fragile CSS classes or XPath
- [ ] No selectors tied to text that changes with i18n or copy updates
- [ ] No selectors tied to implementation details (internal class names, DOM structure)

### Assertion quality
- [ ] Each test asserts a visible outcome — not just that no error was thrown
- [ ] Assertions are specific — not just `toBeTruthy()` or `toExist()`
- [ ] Network responses are asserted where relevant (status codes, payload shape)
- [ ] UI state after action is verified (redirects, toasts, updated lists)

### Test isolation
- [ ] Tests do not share mutable state between runs
- [ ] Database or API state is reset between tests (seeds, fixtures, intercepts)
- [ ] Tests do not depend on execution order
- [ ] Tests do not depend on third-party service availability without mocking

### Reliability / flakiness
- [ ] No fixed `sleep` or `waitForTimeout` — uses event-driven waits
- [ ] Network requests are intercepted and controlled, not left to real latency
- [ ] Animations are disabled or awaited before assertions
- [ ] Retries are not masking root causes

### Maintainability
- [ ] Page Object Model or equivalent abstraction used for repeated interaction patterns
- [ ] Test descriptions clearly state what behavior is being verified
- [ ] Setup and teardown are explicit and documented
- [ ] No copy-pasted test blocks — shared helpers used instead

## Process

1. Identify the e2e test directory and framework in use (Playwright, Cypress, etc.)
2. Read the existing test files
3. Map covered flows against the application's critical user journeys
4. Apply the checklist above
5. Write the report

## Output

Produce a report at `.dev-reports/e2e-validator-<YYYY-MM-DD>.md` with:

- **Executive summary**: coverage score (covered / total critical flows), top 3 risks
- **Missing flows**: flows with no test coverage, ordered by user impact
- **Reliability issues**: flaky patterns found, with file:line references
- **Assertion gaps**: tests that exist but assert too little
- **Selector issues**: fragile selectors that will break on refactor
- **Recommended additions**: concrete test cases to write next, with description and priority
