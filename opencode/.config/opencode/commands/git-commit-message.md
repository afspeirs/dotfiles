---
description: Generate a git commit message with a subject under 50 chars, with an optional body when useful.
agent: general
---

Generate a commit message from this context:

$ARGUMENTS

Requirements:
- Subject line must be less than 50 characters.
- Prefer Conventional Commit prefixes when appropriate (`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`).
- Use imperative mood.
- No trailing period in the subject.
- Include a body only when it adds useful context (why, side effects, or follow-ups).
- If you include a body, put one blank line between subject and body and wrap lines near 72 chars.

Output rules:
- Return only the final commit message text.
- No explanations, no markdown fences.
