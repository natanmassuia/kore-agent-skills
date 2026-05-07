---
name: ui-polish
description: Refine UI components for visual consistency, accessibility, and quality — spacing, color, typography, focus states, ARIA, responsive behavior. Trigger with phrases like "polish the UI", "ui review", "fix the styling", "accessibility check".
compatibility: opencode, claude, codex
---

# UI Polish Skill

## Purpose

Improve the visual quality, consistency, and accessibility of UI components without changing behavior or business logic. Every change should make the interface more predictable, more accessible, or more consistent with the design system.

## Trigger phrases

- "polish the UI"
- "ui review"
- "fix the styling"
- "accessibility check"
- "make it look better"
- "responsive issues"

## Rules

- No secrets, no tokens, no hardcoded credentials
- No destructive file operations
- Do not change component behavior, props API, or data fetching
- Do not add new features
- Follow the project's existing design tokens — do not introduce new color values or spacing constants
- All interactive elements must be keyboard accessible
- All images must have meaningful `alt` text or `aria-hidden="true"` if decorative

## Polish checklist

### Visual consistency
- [ ] Spacing uses design tokens / Tailwind scale — no arbitrary pixel values
- [ ] Typography uses defined type scale — no one-off font sizes
- [ ] Colors use design system tokens — no raw hex or rgb values
- [ ] Icons are consistent in size and stroke weight across the view
- [ ] Border radii are consistent with the design system
- [ ] Shadow levels are used consistently (not mixed)

### Accessibility (WCAG 2.1 AA minimum)
- [ ] All interactive elements have visible focus indicators
- [ ] Color contrast meets 4.5:1 for normal text, 3:1 for large text
- [ ] All form inputs have associated `<label>` elements
- [ ] All images have `alt` text (or `aria-hidden="true"` if decorative)
- [ ] Buttons and links have descriptive accessible names (not "click here")
- [ ] ARIA roles and attributes are used correctly — no redundant or conflicting roles
- [ ] Modal dialogs trap focus and restore focus on close
- [ ] No content relies on color alone to convey meaning

### Responsive behavior
- [ ] Layout does not overflow or clip at 320px width
- [ ] Touch targets are at least 44×44px on mobile viewports
- [ ] Text remains readable at 200% browser zoom
- [ ] Horizontal scrolling is not introduced on mobile

### States
- [ ] Loading states are shown — no blank content during async operations
- [ ] Empty states are handled — no bare empty containers
- [ ] Error states are shown clearly and do not expose internal error messages
- [ ] Disabled states are visually distinguishable and have `aria-disabled`

### Motion
- [ ] Animations respect `prefers-reduced-motion`
- [ ] Transitions are under 300ms for micro-interactions

## Process

1. Identify the components or views in scope
2. Read all relevant component, style, and token files
3. Apply the checklist
4. Make changes — one concern at a time (spacing, then accessibility, then responsive)
5. Note any issues that require design decisions and cannot be resolved without input

## Output

- Apply changes directly to the relevant files
- Produce a report at `.dev-reports/ui-polish-<YYYY-MM-DD>.md` with:
  - Changes made (file and line references)
  - Accessibility issues resolved
  - Issues that require design input and were left unchanged
  - Any WCAG violations that remain after this pass
