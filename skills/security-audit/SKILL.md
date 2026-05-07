---
name: security-audit
description: Review code for security vulnerabilities aligned to OWASP Top 10 and Kore security standards. Trigger with phrases like "security audit", "check for vulnerabilities", "security review".
compatibility: opencode, claude, codex
---

# Security Audit Skill

## Purpose

Identify security vulnerabilities in a given code path, module, or feature. Produce a prioritized report with severity ratings and recommended remediations. Do not exploit or prove vulnerabilities — report them.

## Trigger phrases

- "security audit"
- "security review"
- "check for vulnerabilities"
- "is this safe"
- "OWASP check"

## Rules

- No secrets, no tokens, no hardcoded credentials
- No destructive file operations
- Do not generate exploit code or proof-of-concept attacks
- Do not commit or push changes — report only
- Flag all hardcoded secrets, tokens, or credentials found in code immediately
- Respect Kore's existing permission and role model — do not suggest bypassing it

## Vulnerability checklist (OWASP Top 10 aligned)

### Injection
- [ ] SQL injection — string concatenation into queries without parameterization
- [ ] Command injection — user input passed to shell commands
- [ ] Template injection — user-controlled data rendered in server-side templates
- [ ] XSS — unsanitized user input rendered as HTML

### Authentication & authorization
- [ ] Missing authentication on endpoints that require it
- [ ] Broken object-level authorization (BOLA/IDOR) — user A can access user B's resources
- [ ] JWT or session token mishandling (weak secrets, no expiry, no rotation)
- [ ] Privilege escalation paths

### Sensitive data exposure
- [ ] Secrets, API keys, or credentials in source code or config files
- [ ] PII logged to console or stored without appropriate protection
- [ ] Sensitive fields returned in API responses that don't need them
- [ ] Data transmitted without TLS

### Misconfiguration
- [ ] Debug mode or verbose errors enabled in production paths
- [ ] CORS wildcard (`*`) on authenticated endpoints
- [ ] Missing security headers (CSP, HSTS, X-Frame-Options)
- [ ] Overly permissive file uploads (no type or size validation)

### Dependencies
- [ ] Known vulnerable packages (flag for manual review — do not auto-upgrade)
- [ ] Packages imported but unused

### Business logic
- [ ] Rate limiting absent on sensitive endpoints (login, password reset, OTP)
- [ ] Mass assignment — user-supplied fields bound to model without allowlist
- [ ] Insecure direct references to internal IDs

## Severity scale

| Severity | Meaning |
|---|---|
| Critical | Exploitable without authentication; immediate data loss or takeover risk |
| High | Exploitable with low-privilege access; significant data or integrity risk |
| Medium | Requires specific conditions; partial data exposure or logic bypass |
| Low | Defense-in-depth issue; no direct exploit path |
| Info | Best-practice gap with no current exploit path |

## Process

1. Identify the code scope from the user's request
2. Read all relevant files — routes, controllers, models, middleware, config
3. Apply the checklist above
4. Rate each finding using the severity scale
5. Write the report

## Output

Produce a report at `.dev-reports/security-audit-<YYYY-MM-DD>.md` with:

- **Executive summary**: total findings by severity
- **Critical and high findings**: one section each with file:line references and recommended fix
- **Medium and low findings**: condensed table format
- **Informational notes**: best-practice gaps
- **Out of scope**: anything that was not reviewed and why
