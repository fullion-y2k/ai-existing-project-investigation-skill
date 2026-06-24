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

## Explorer Ticket

Use this shorter ticket for Standard and Heavy routes before the orchestrator performs deep file reading.

```text
Explorer Ticket
Worktree Lock:
Task:
Why this is delegated:
Allowed search roots:
Allowed search terms:
Files already known:
Do not read:
Do not do:
Evidence needed:
Stop and return if:
Output limit:
```

Default output limit: 10 bullets plus file paths and command names. No diary.

## Explorer Output

```text
Explorer Output
Worktree Lock used:
Worktree verified:
Findings:
Evidence:
Files read:
Important candidates not read:
Commands run:
Result:
Inference:
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
- Use only the Worktree Lock paths.
- Before any repository search, file read, edit, test, or build, verify current directory and git top-level against the Worktree Lock.
- Return `BLOCKER: worktree mismatch` if the lock is missing, the tool starts in a different directory, a different git root appears, or any assigned path is outside the lock.
- Do not infer, search for, or `cd` into a similar repo/worktree.
- Return blockers to the orchestrator.
- Mark evidence and inference separately.
- Keep the result short enough for direct orchestration.
