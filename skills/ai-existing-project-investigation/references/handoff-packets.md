# Handoff Packets

Use compact packets. Do not include full conversation dumps, long code paste, duplicated requirements, or diary-style reports.

Every `Worktree Lock` block must include `Confirmed working folder`, `Expected git top-level`, `Allowed read root`, `Allowed edit root`, and known forbidden sibling worktrees.

## Explorer Input

```text
Explorer Input
Worktree Lock:
Objective:
Acceptance criteria:
Route:
Allowed scope:
Disallowed scope:
Relevant files / symbols / search terms:
Known evidence:
Hypothesis to check:
Assigned action:
Required verification:
Blocker return format:
```

## Atomic Explorer Ticket

Use this shorter ticket for Standard and Heavy routes before the orchestrator performs deep file reading.

```text
Atomic Explorer Ticket
Worktree Lock:
Evidence question:
Why this is delegated:
Allowed search roots:
Allowed search terms:
Allowed files:
Do not read:
Do not do:
Evidence needed:
Output format:
Stop and return if:
Output limit:
```

Default output limit: 10 bullets plus file paths and command names. No diary. Return Observed facts only.

## Explorer Ticket Quality Gate

Before sending a ticket, confirm:

- The ticket asks exactly one evidence question.
- The search root is bounded and inside the Worktree Lock.
- Search terms are listed and limited to 5.
- Allowed files are listed and limited to 5, or one bounded directory is used.
- The ticket does not ask for product decisions, design judgment, broad diagnosis, or implementation decisions.
- The output requires Observed facts only.
- The output limit is explicit.
- Worktree Lock is included.

If the ticket fails this gate, split it into smaller tickets before delegation.

## Explorer Output

```text
Explorer Output
Worktree Lock used:
Worktree verified:
Observed facts:
Unknowns:
Files read:
Important candidates not read:
Commands run:
Result:
Blockers:
Remaining risk:
```

## Implementation Handoff

Use this only after investigation is complete.

```text
Implementation Handoff
Worktree Lock:
Worktree verified:
Objective:
Acceptance criteria:
Likely cause / change point:
In scope:
Out of scope:
Disallowed changes:
Relevant files and symbols:
Evidence:
Observed evidence:
Derived findings:
Unknowns:
Implementation candidates:
Required verification:
Regression risks:
Open blockers:
Recommended route for implementation:
```

## Explorer Guardrails

Tell explorers:

- Read only.
- Do not edit files.
- Do not ask the user questions.
- Do not broaden scope without evidence.
- Do not decide the overall investigation route.
- Do not produce broad diagnosis, design judgment, or implementation decisions.
- Return Observed facts only; mark unconfirmed items as Unknown.
- Use only the Worktree Lock paths.
- Before any repository search, file read, edit, test, or build, verify current directory and git top-level against the Worktree Lock.
- Return `BLOCKER: worktree mismatch` if the lock is missing, the tool starts in a different directory, a different git root appears, or any assigned path is outside the lock.
- Do not infer, search for, or `cd` into a similar repo/worktree.
- Return blockers to the orchestrator.
- Mark evidence and inference separately.
- Keep the result short enough for direct orchestration.
