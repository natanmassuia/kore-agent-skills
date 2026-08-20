---
name: security-source-audit
description: Audit the source code of internal "vibecoded" systems — operations dashboards, network automation, collectors, multi-vendor integrations — covering equipment credentials, command/SSH injection, hardcoded secrets, and operational hardening. Trigger with phrases like "source audit", "security source audit", "audit the source", "is this safe to operate".
compatibility: opencode, claude, codex
---

# Security Source Audit

## Purpose

Source audit for internal systems built without supervision ("vibecoded"): operations dashboard, network automation, collector, multi-vendor integration. Cross-check the code against a verifiable checklist (OWASP/ASVS) instead of auditing from memory — every finding backed by the line that proves it.

The lens that guides everything: an app that stores equipment credentials and pushes config/commands to a router, firewall, or switch does not store "data" — it stores the keys to the network. Compromise means lateral movement into the whole infrastructure. If the system talks to equipment, start there.

## Trigger phrases

- "source audit"
- "security source audit"
- "audit the source"
- "is this app safe to operate"
- "vibecoded audit"

## Rules

- Non-destructive by default. Explicit authorization and a single target before touching anything. Never trigger a real automation endpoint (firewall, reboot, config push) during testing.
- Mask secrets. Describe by behavior; never print email/hash/credential in the report.
- Evidence-based verdicts, ASVS style: PASS / FAIL / NOT APPLICABLE / TO VERIFY — each with the proving line. "To verify" is not "pass".
- Separate security defects from operational/continuity risk — they are different decisions for the person receiving the report.
- No secrets, no tokens, no hardcoded credentials
- No destructive file operations

## When to use

- Review the code of an internal dashboard, network automation, collector, or integration.
- Audit a "vibecoded" system before taking over maintenance or the author leaves.
- Evaluate an app before exposing it on a larger network or granting more access.

## The 5 axes (always cover)

1. Role-based authorization — every route checks role/permission on the server, or just "is logged in"? A role gate in the browser does not count. Test a normal account against admin/automation routes. (ASVS V8.)
2. Password storage — strong hash (argon2id/bcrypt/PBKDF2 with >=600k iterations) with per-user salt, or plaintext/MD5/SHA1 unsalted? Good sign: a dedicated hash module with constant-time verification.
3. Injection — concatenated SQL (use ORM/parameterized); especially command/SSH injection in automations — operator input becoming a command on the equipment or the shell. This is the highest-damage vector here.
4. Hardcoded secrets — DB/equipment/API credentials, keys, tokens, gear IPs in code or in the delivered bundle. Run gitleaks/grep over the source and the git history (a secret deleted in a commit still lives in history).
5. How automation reaches the equipment — where the credentials live, how the command is built, and what happens if the target/argument is hostile. Operator-free commands reaching production equipment is the worst attack surface.

## Hardening checklist

### Group 1 — exposure
- [ ] DB/cache ports (Postgres/MySQL/Redis) closed to the network
- [ ] Real passwords (no defaults like admin/admin, postgres, changeme, root)
- [ ] CORS by explicit origin, not `*`

### Group 2 — transport and edge
- [ ] Production build (not dev server — dev server leaks stack traces and absolute paths)
- [ ] Real TLS
- [ ] Security headers (HSTS/CSP/X-Frame-Options/nosniff)
- [ ] Rate limiting on login
- [ ] Severity order: TLS > rate limit > production build > headers

### Group 3 — data at rest
- [ ] Encrypted DB backups with rehearsed restore (a backup never restored is not a backup)
- [ ] App does not run as DB superuser (least privilege)
- [ ] Connection logging enabled

### Session and credentials
- [ ] Session cookie with Secure + HttpOnly + SameSite
- [ ] Sessions with expiry and revocation
- [ ] Password change requires re-authentication
- [ ] Equipment secrets encrypted at rest, not plaintext in .env
- [ ] Key rotation planned
- [ ] Audit trail with integrity

### Operational (continuity, not just security)
- [ ] Process running from a personal directory / under a nominal user account dies when the account is deactivated — red flag: operations depend on a single individual

## Red flags (quick scan)

- [ ] Admin gate decided in JavaScript (`if (role === "admin")` on the client)
- [ ] Endpoint answers "must be logged in" but does not check the role
- [ ] Stack trace / absolute path in error response (non-production environment)
- [ ] Session cookie without Secure over plain HTTP
- [ ] SSH without host key verification (accepts any key on first contact)
- [ ] Endpoint executes arbitrary operator commands on the equipment
- [ ] External CDN/asset at runtime (breaks without internet; supply chain risk)
- [ ] Default or "change later" password still active
- [ ] Real secret committed (search the git history too)

## Process

1. Confirm scope and authorization; agree a single target with the requester
2. Read the relevant code — routes, controllers, automation/agent modules, config, deployment
3. Cover the 5 axes, then walk the hardening checklist and red flags
4. Record each finding with file:line evidence
5. Classify each finding as security defect or operational/continuity risk
6. Order findings by risk (not by ease of fix), with the concrete failure vector
7. Write the report

## Output

Produce a report at `.dev-reports/security-source-audit-<YYYY-MM-DD>.md` with:

- **Scope and authorization**: what was audited, single target, who authorized
- **Verdict summary**: per ASVS — PASS / FAIL / NOT APPLICABLE / TO VERIFY
- **5 axes coverage**: each axis with evidence by file/line
- **Findings**: ordered by risk, each with concrete failure vector and a specific remediation — what to change, not just what is wrong
- **Security vs operational/continuity**: separated sections
- **Out of scope**: anything not reviewed and why
- **Secret hygiene**: masked secrets only; no sensitive data leaked in the report