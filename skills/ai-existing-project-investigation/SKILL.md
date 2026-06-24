---
name: ai-existing-project-investigation
description: Existing project investigation workflow for Codex before bug fixes or feature changes. Use when Codex must inspect existing code, identify likely cause or impact, prepare an implementation handoff, and control mini-model explorer subagents without starting implementation.
---

# AI Existing Project Investigation

Use this skill to investigate an existing codebase before implementation. The goal is to reduce unnecessary token usage, duplicated investigation, and rework by keeping the orchestrator in control and giving mini-model explorers bounded read-only tasks.

This skill is not an implementation workflow. If the user asks to implement after investigation, finish the investigation report first, then hand off to an implementation skill such as `ai-existing-project-change`.

## Core Rules

- The orchestrator owns the objective, route, scope, hypotheses, evidence review, and final report.
- Do not use a mini model as orchestrator for multi-step investigation.
- Use mini models only as bounded read-only explorers with compact handoff packets.
- Do not let explorers choose the overall investigation direction.
- Do not pass the full conversation to subagents.
- Do not ask humans for facts that can be read from the repository.
- Ask humans only for blockers or competing valid interpretations.
- Ask at most 3 blocking questions at once and include recommended options.
- Subagents must not ask the user directly; they return blockers to the orchestrator.
- Separate evidence from inference.
- Prefer `rg` or symbol search before opening files.
- Avoid broad scans unless the route is Heavy and the scan is explicitly bounded.
- Do not implement, refactor, reformat, or edit application code.
- Do not run destructive commands or write to production-like systems.
- For Standard or Heavy, keep the orchestrator as the brain, not the file reader.
- Confirm the working folder before project investigation and require every subagent to use that confirmed folder.

## Workspace Confirmation Gate

This gate runs before Route Decision and before reading project files.

1. Identify the intended working folder or worktree from the user request, current directory, or explicit path.
2. Show the candidate folder to the user and ask for confirmation before investigation:

```text
Workspace Confirmation
Candidate working folder:
Reason:
I will use this folder for the orchestrator and all subagents. OK to continue?
```

3. Do not inspect project files, run repository searches, or delegate subagents until the user confirms.
4. After confirmation, record the exact absolute path as `Confirmed working folder`.
5. The orchestrator must pass `Confirmed working folder` to every subagent.
6. Every command, search root, file path, artifact path, and handoff packet must stay inside the confirmed folder unless the user explicitly approves another path.
7. If any tool starts in a different directory or discovers a different git root/worktree, stop and ask for confirmation again.

## Route Decision

Start by producing this checkpoint, then continue the investigation unless a stop condition is met.

```text
Investigation Route Decision
Confirmed working folder:
Route:
Reasons:
Blocking questions:
Assumptions:
Allowed investigation scope:
Disallowed scope:
Explorer plan:
Delegation gate:
Verification / reproduction plan:
Escalation triggers:
```

### Fast Track Investigation

Use Fast Track when the target is clear, acceptance criteria are clear, risk is low, likely files are known, and the investigation is usually 1-3 files.

- Prefer no subagent.
- Do not create long artifacts.
- Confirm the relevant code path and likely change point.
- Produce a short investigation report.

### Standard Investigation

Use Standard when impact spans multiple files or layers, cause is uncertain but bounded, or the request needs a reusable implementation handoff.

- Use one `explorer-mini` subagent when subagent tools are available.
- After route decision, the orchestrator may run only enough search to create an Explorer Ticket; do not continue direct file reading first.
- Give the explorer one bounded read-only task.
- The orchestrator reviews the explorer output against repository evidence before concluding.
- Produce an implementation handoff packet.

### Heavy Investigation

Use Heavy when the work touches or may touch DB schema, migrations, initializer data correction, public API contracts, auth, permissions, security, external integrations, production data, data-loss risk, or broad unknown impact.

- Use up to two independent read-only explorers when available.
- Split explorers by boundary, not by duplicated search.
- Use explorer-first investigation: delegate before the orchestrator reads deep file bodies.
- Use a stronger reviewer when available for final investigation review.
- Require a go/no-go recommendation before implementation.

## Subagent Contract

The Skill itself is the delegation instruction. Do not require the user to explicitly request subagents.

For Standard or Heavy, first check whether subagent tools are available. If they are available, use `explorer-mini` for one bounded read-only investigation task before concluding. If they are unavailable, say `Subagent unavailable: <specific tool availability reason>` before continuing.

Delegation gate for Standard or Heavy:

1. Before deep investigation, write `Delegation gate: explorer required`.
2. Create an `Explorer Ticket` from `references/handoff-packets.md`.
3. Delegate the ticket to `explorer-mini` if a subagent tool is callable.
4. Until the explorer returns, the orchestrator may only read files needed to validate the ticket or resolve a blocker.
5. If no callable subagent tool exists, write `Subagent unavailable: <specific tool availability reason>` and continue with a reduced direct-investigation budget.

Reduced direct-investigation budget when subagents are unavailable:

- Use targeted `rg` first.
- Prefer snippets over full files.
- Read no more than 3 primary files before producing an interim report or narrowing ticket.
- Do not perform broad exploratory reading as a substitute for delegation.

Valid no-explorer reasons:

- Subagent tools are unavailable.
- The route is Fast Track.
- The explorer returned a blocker.
- The task requires orchestrator-only context that cannot be safely summarized.

Invalid no-explorer reasons:

- Preference or convenience.
- Missing explicit user delegation wording.
- The user did not explicitly ask for subagents.
- Current delegation rule does not require it.
- "Safer to do directly."
- The scope looks small after the route was already classified as Standard or Heavy.
- The orchestrator has already started reading files.

Use the handoff and output formats in `references/handoff-packets.md`.

## Investigation Method

1. Run Workspace Confirmation Gate and wait for user confirmation.
2. Restate the investigation objective and acceptance criteria from the user request or specification.
3. Classify Fast Track, Standard, or Heavy.
4. Search narrowly first inside the confirmed folder: names, routes, symbols, error text, config keys, schema names.
5. For Standard or Heavy, create and delegate an Explorer Ticket before deep file reading.
6. Read only files inside the confirmed folder that explain the code path or impact boundary.
7. Keep a list of files read and important candidates not read.
8. Build cause hypotheses from evidence.
9. Disprove or downgrade weak hypotheses.
10. Identify the smallest plausible implementation area.
11. Report risks, blockers, and what should be verified during implementation.

For detailed report templates, read `references/report-templates.md`.

## Stop Conditions

Stop and ask the orchestrator/user only when:

- The requested behavior conflicts with repository evidence.
- Multiple valid product or data choices exist.
- Required files or specifications are missing.
- Investigation would require secrets, credentials, production writes, or destructive actions.
- Heavy risk appears but cannot be bounded from repository evidence.

## Final Report

End with:

```text
Investigation Report
Confirmed working folder:
Route:
Objective:
Acceptance criteria understood:
Agents used:
Delegation gate result:
Scope investigated:
Files read:
Important candidates not read:
Evidence:
Inference:
Likely cause / change point:
Alternative hypotheses:
Impact area:
Implementation handoff:
Recommended next step:
Remaining risk:
Blockers:
```
