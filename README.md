# AI Existing Project Investigation Skill

This repository contains a Codex skill for bounded investigation of existing projects before bug fixes or feature changes.

The skill is designed for a strong orchestrator model such as `gpt-5.4` or `gpt-5.5` with medium reasoning. Mini models are intended as read-only explorer subagents for bounded investigation tasks, not as the main orchestrator.

## Install on this PC

Copy the skill folder to your Codex skill directory:

```powershell
New-Item -ItemType Directory -Force "$HOME\.agents\skills" | Out-Null
Copy-Item -Recurse -Force ".\skills\ai-existing-project-investigation" "$HOME\.agents\skills\"
```

Restart Codex or start a new session if the skill list does not refresh.

## Use

```text
$ai-existing-project-investigation
既存プロジェクトで、以下の不具合の原因と影響範囲を調査してください。
実装はまだ行わず、調査結果と実装引き継ぎを出してください。
```

## Expected Behavior

- Route Decision を出してから調査を続行する
- Fast Track ではサブエージェントなしでもよい
- Standard 以上では、利用可能なら mini explorer を使う
- ユーザーが明示的に subagent 利用を依頼していなくても、スキル自体を delegation 指示として扱う
- subagent を使わない場合は、具体的な tool availability reason を書く
- mini explorer には調査範囲を限定した handoff packet だけ渡す
- 実装・リファクタ・フォーマット変更はしない
- evidence と inference を分ける
- 最後に implementation handoff を出す

## Update

If the repository is already cloned:

```powershell
cd ai-existing-project-investigation-skill
git pull
Remove-Item -Recurse -Force "$HOME\.agents\skills\ai-existing-project-investigation"
Copy-Item -Recurse -Force ".\skills\ai-existing-project-investigation" "$HOME\.agents\skills\"
```

Start a new Codex session after updating so the skill list is refreshed.

## Notes

This skill does not guarantee fixed token or cost savings. It aims to reduce unnecessary token usage, duplicated investigation, and rework by controlling investigation scope.
