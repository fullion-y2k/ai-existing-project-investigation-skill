# Handoff Packets

Use compact packets. Do not include full conversation dumps, long code paste, duplicated requirements, or diary-style reports.

## Explorer Input

```text
Explorer Input
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
- Return blockers to the orchestrator.
- Mark evidence and inference separately.
- Keep the result short enough for direct orchestration.
