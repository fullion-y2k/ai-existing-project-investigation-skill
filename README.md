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

If an existing skill directory is found, it is moved to:

- `$HOME\.agents\skill-backups\ai-existing-project-investigation.backup-<timestamp>`

Restart Codex or start a new session after installing or updating so the skill list is refreshed.

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
- 確認済み作業フォルダを Route Decision、Explorer Ticket、Final Report に含める
- 司令塔と全 subagent は、確認済み作業フォルダ内だけを使う
- Route Decision を出してから調査を続行する
- Fast Track ではサブエージェントなしでもよい
- Standard 以上では、利用可能なら mini explorer を使う
- Standard 以上では、オーケストレーターが深いファイル読み取りを始める前に Explorer Ticket を切る
- オーケストレーターは頭脳として方針・統合・判断に集中し、ファイル読み取りは explorer に寄せる
- ユーザーが明示的に subagent 利用を依頼していなくても、スキル自体を delegation 指示として扱う
- subagent を使わない場合は、具体的な tool availability reason を書く
- mini explorer には調査範囲を限定した handoff packet だけ渡す
- 実装・リファクタ・フォーマット変更はしない
- evidence と inference を分ける
- 最後に implementation handoff を出す

## Notes

This skill does not guarantee fixed token or cost savings. It aims to reduce unnecessary token usage, duplicated investigation, and rework by controlling investigation scope.
