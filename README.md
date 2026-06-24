# AI Existing Project Investigation Skill

This repository contains a Codex skill for bounded investigation of existing projects before bug fixes or feature changes.

The skill is designed for a strong orchestrator model such as `gpt-5.4` or `gpt-5.5` with medium reasoning. Mini models are intended as read-only explorer subagents for bounded investigation tasks, not as the main orchestrator.

## Install or Update

From a cloned repository:

```powershell
.\install.ps1
```

Dry run:

```powershell
.\install.ps1 -DryRun
```

The script copies:

- `skills/ai-existing-project-investigation` to `$HOME\.agents\skills\ai-existing-project-investigation`
- `agents/openai-codex/*.toml` to `$HOME\.codex\agents\`

Existing files are backed up outside active discovery paths:

- Skills: `$HOME\.agents\skill-backups\`
- Agents: `$HOME\.codex\agent-backups\`

Restart Codex or start a new session after installing or updating so the skill and agent list is refreshed.

## First-Time Clone

```powershell
git clone https://github.com/fullion-y2k/ai-existing-project-investigation-skill.git
cd ai-existing-project-investigation-skill
.\install.ps1
```

## Update Existing Clone

```powershell
cd ai-existing-project-investigation-skill
git pull
.\install.ps1
```

## Use

```text
$ai-existing-project-investigation
既存プロジェクトで、以下の不具合の原因と影響範囲を調査してください。
実装はまだ行わず、調査結果と実装引き継ぎを出してください。
```

## Expected Behavior

- 調査前に作業フォルダ/worktree をユーザーへ確認し、OK が出るまで project file 調査に入らない
- OK 後に `Worktree Lock` を作る
- `Worktree Lock` には confirmed working folder、expected git top-level、branch/worktree name、allowed read/edit root、forbidden sibling worktrees を含める
- 司令塔と全 subagent は `Worktree Lock` 内だけを使う
- 全 subagent handoff には `Worktree Lock` を必ず含める
- subagent は読み取り前に cwd / git top-level / allowed root を照合する
- 不一致時は `BLOCKER: worktree mismatch` で停止する
- repo や worktree を推測して `cd` しない
- Route Decision を出してから調査を続行する
- Standard 以上では、利用可能なら mini explorer を使う
- Standard 以上では、オーケストレーターが深いファイル読み取りを始める前に Explorer Ticket を切る
- オーケストレーターは頭脳として方針・統合・判断に集中し、ファイル読み取りは explorer に寄せる
- evidence と inference を分ける
- 最後に `Worktree verified` と implementation handoff を出す

## Validate

```powershell
python validate.py
```

The validator checks that Skill and Agent instructions include `Worktree Lock` and `BLOCKER: worktree mismatch`.

## Notes

This skill does not guarantee fixed token or cost savings. It aims to reduce unnecessary token usage, duplicated investigation, and rework by controlling investigation scope.
