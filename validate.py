from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parent
REQUIRED_TEXT = [
    "Worktree Lock",
    "BLOCKER: worktree mismatch",
]


def fail(message: str) -> None:
    print(f"FAIL: {message}")
    sys.exit(1)


def check_file(path: Path, label: str) -> str:
    if not path.exists():
        fail(f"{label} missing: {path}")
    text = path.read_text(encoding="utf-8")
    for phrase in REQUIRED_TEXT:
        if phrase not in text:
            fail(f"{label} missing required phrase: {phrase}")
    return text


def check_skill() -> None:
    skill = ROOT / "skills" / "ai-existing-project-investigation" / "SKILL.md"
    text = check_file(skill, "Skill")
    if not text.startswith("---\n"):
        fail("Skill missing YAML frontmatter")
    if "name: ai-existing-project-investigation" not in text:
        fail("Skill missing expected name")
    if "description:" not in text:
        fail("Skill missing description")
    for phrase in [
        "Workspace Confirmation And Worktree Lock",
        "Worktree verified",
        "Expected git top-level",
        "Allowed edit root",
        "Forbidden sibling worktrees",
        "Evidence Discipline",
        "Atomic Explorer Ticket",
        "Observed",
        "Derived",
        "Unknown",
        "Cause not confirmed",
    ]:
        if phrase not in text:
            fail(f"Skill missing required Worktree Lock field: {phrase}")


def check_agents() -> None:
    agent_dir = ROOT / "agents" / "openai-codex"
    if not agent_dir.exists():
        fail("Agent directory missing")
    agent_files = sorted(agent_dir.glob("*.toml"))
    if not agent_files:
        fail("No agent TOML files found")
    for path in agent_files:
        text = check_file(path, f"Agent {path.name}")
        for key in [
            "name",
            "description",
            "model",
            "model_reasoning_effort",
            "sandbox_mode",
            "developer_instructions",
        ]:
            if f"{key} =" not in text:
                fail(f"Agent {path.name} missing key: {key}")


def check_references() -> None:
    ref = ROOT / "skills" / "ai-existing-project-investigation" / "references" / "handoff-packets.md"
    text = check_file(ref, "Handoff reference")
    for phrase in ["Worktree Lock used", "Worktree verified", "Confirmed working folder"]:
        if phrase not in text:
            fail(f"Handoff reference missing: {phrase}")
    for phrase in ["Atomic Explorer Ticket", "Explorer Ticket Quality Gate", "Observed facts only"]:
        if phrase not in text:
            fail(f"Handoff reference missing evidence discipline phrase: {phrase}")


def main() -> None:
    check_skill()
    check_agents()
    check_references()
    print("PASS")


if __name__ == "__main__":
    main()
