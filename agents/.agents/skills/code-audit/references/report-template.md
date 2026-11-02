# AUDIT.md — <project> audit & action plan

Audit date: YYYY-MM-DD · branch `<branch>` @ `<commit>`

Working document: tick boxes as items land. Each phase is independently shippable —
run the **Verification** block at the end of every phase before moving on.

Baseline at audit time:

| Check | Result |
| --- | --- |
| `<test command>` | N passed, M files |
| `<typecheck command>` | 0 errors |
| `<lint command>` | clean |
| `<dependency audit>` | 0 vulnerabilities |

---

## Open questions to settle before Phase N

1. **Question** — what is ambiguous, what it decides, which finding/step depends on it.

---

## Findings

### P1 — bugs and behavior that contradicts the docs

| # | Finding | Where |
| --- | --- | --- |
| 1 | **One-line claim.** What the code actually does, why it is wrong. | `path/file.ts:12`, `symbolName` |

### P2 — architecture and maintainability

| # | Finding | Where |
| --- | --- | --- |

### P3 — documentation drift (misleads the next session)

| # | Finding |
| --- | --- |
|   | `<doc>` claims "<quote the claim>" — **false**; `<reality, with path>`. |

### P4 — accessibility

| # | Finding | Where |
| --- | --- | --- |

### P5 — performance and dead weight

| # | Finding | Where |
| --- | --- | --- |

### P6 — tooling, CI, tests

| # | Finding |
| --- | --- |

---

## Action plan

### Phase 1 — quick fixes (no new deps, low risk)

- [ ] **1.1** <change>.
- [ ] **1.2** <change>. **Deviation from plan:** <what actually happened and why>.

**Verification (Phase 1, run YYYY-MM-DD):** `<test command>` → N passed (was M) ·
`<typecheck>` → clean · `<lint>` → clean · `<build>` → ok (<bundle sizes>).
Still to check by hand: <manual checks, named>.

### Phase 2 — consistency and durability (answers open questions N–M)

- [ ] **2.1** <change> (`path:line`).

**Verification:** `<commands>`; manual pass of <flows>.

### Phase 3 — tests and CI

- [ ] **3.1** <change>.

**Verification:** <commands>, then confirm the CI run goes green on the branch.

### Phase 4 — structure (mechanical, biggest payoff, do it on its own branch)

- [ ] **4.1** <extraction>, `src/<dir>/`.

**Verification:** `<commands>`; then a manual click-through of every route/entry point.

### Phase 5 — docs and polish

- [ ] **5.1** <doc to rewrite and the claims to fix>.

**Verification:** read-through of the docs against `<src>` (every named path must exist),
`<build + preview>` → <browser/tool check>.

---

## Recommended skills to write

Project skills go in `.agents/skills/<name>/SKILL.md` (repo-shared); cross-project ones go
in `~/.agents/skills/`. Each needs frontmatter `name` + a `description` that says *what* it
does **and when** to load it — the description is the routing signal.

**1. `<name>`** — the ceremony this repo repeats, step by step, and the finding it prevents.

---

## Risks

- <large diff — how to split it>.
- <product decision with data consequences — prefer the reversible option>.
- <change that can invalidate existing user data, links, or records — keep the read path
  permissive and tighten only the write path; call it out in the commit message>.
- <tooling change that surfaces many errors at once — land separately from feature work>.
- <no rollback plan for user data — export a backup before touching persistence>.
