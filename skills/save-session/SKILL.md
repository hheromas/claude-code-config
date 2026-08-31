---
name: save-session
description: Trigger when user wants to save session state for later resumption. Use when "save session", "セッション保存", "session handoff", "pause work", "resume later", "引き継ぎ" is requested.
argument-hint: "[session-id or description]"
allowed-tools: Read, Glob, Grep, Bash, Write, Edit, AskUserQuestion
---

# Save Session

Save current session state to a structured file for seamless resumption in a new session.

## Output Location

`~/.claude/session-data/YYYY-MM-DD-<session-id>-session.md`

- `<session-id>`: From `$ARGUMENTS`, or auto-generate from task name / branch name.
- Create `~/.claude/session-data/` if it does not exist.

## Procedure

1. **Gather context**: Read plan.md, recent work/ files, git status, git log (last 10 commits), and current branch.
2. **Build session file**: Write all 7 sections below. Each section must be factual -- no speculation. If unknown, write "Not yet determined."
3. **Save file**: Write to the output location.
4. **Confirm**: Print the file path and a 3-line summary.

## 7-Section Structure

```markdown
# Session: <session-id>
Date: YYYY-MM-DD HH:MM
Branch: <branch-name>
Task: <task-folder-path>

## 1. What We Are Building
<!-- One paragraph: goal, scope, success criteria. Link to plan.md. -->

## 2. What WORKED
<!-- Bullet list of approaches, tools, decisions that succeeded. Include file paths. -->

## 3. What Did NOT Work
<!-- Bullet list of failed approaches with WHY they failed. Saves the next session from repeating. -->

## 4. What Has NOT Been Tried Yet
<!-- Ideas, alternative approaches, or backlog items still pending. -->

## 5. Current State of Files
<!-- Key files with their current status: modified, created, deleted, needs-review. -->
<!-- Include `git status` output and any uncommitted changes. -->

## 6. Decisions Made
<!-- Architecture/design decisions with rationale. Once decided, next session should not revisit. -->

## 7. Exact Next Step
<!-- ONE specific, actionable step to start the next session. Not a list -- one thing. -->
<!-- Include the exact command or file to open. -->
```

## Integration with order/ Workflow

- If working in an order/ task, reference the plan.md Phase/Step currently active.
- If work/ dump files exist, reference the latest STEP file rather than duplicating content.
- The session file supplements (does not replace) work/ dumps.

## Gotchas

- **Do not speculate**: Every line must be based on files you actually read in this session. If you did not read it, say "Not verified."
- **Exact Next Step must be singular**: "Continue Phase 2" is too vague. "Read `work/P02_STEP03_analysis.md` and implement the fix for the date parsing bug in `src/parser.py:45`" is correct.
- **Git state matters**: Always capture uncommitted changes. The next session needs to know if there is dirty state.
- **Overwrite protection**: If a file with the same session-id already exists, append a numeric suffix (`-2`, `-3`) rather than overwriting.
