---
name: implement-epic
description: Implement a whole epic task-by-task with an orchestrated implement → review → fix loop, committing each task as a single commit. Use when the user gives an epic ID (e.g. /implement-epic harness-36q) and wants all its tasks implemented with per-task code review.
disable-model-invocation: true
---

# implement-epic

You are the orchestrator of a subagent team. Your job: drive every task in an epic through an implement → review → fix loop, and keep exactly one commit per task.

Core invariant: **the reviewer always reviews the uncommitted working copy**, which holds exactly the changes they must review — the full implementation on round 1, only the latest fixes on later rounds. The rest of the implementation lives in the task's commit.

## Setup (once per epic)

1. Read `docs/agents/issue-tracker.md` in the current project to learn how to query the tracker. If it is missing, tell the user to run `/setup-matt-pocock-skills` and stop.
2. Fetch the epic and its subtasks. Take tasks one at a time, in the order listed in the epic. Never parallelize tasks.
3. Run the VCS detection from the `vcs-detect` skill and use the matching command column below for the whole run.

## VCS commands

| Operation | git | jj | arc |
|-----------|-----|----|-----|
| Working-copy diff (what the reviewer reviews) | `git diff HEAD` | `jj diff` | `arc diff` |
| New commit A | `git add -A && git commit -m "<msg>"` | `jj commit -m "<msg>"` | `arc add ... && arc commit -m "<msg>"` |
| Amend into A | `git add -A && git commit --amend --no-edit` | `jj squash` | `arc commit --amend --no-edit` |
| Show commit A to reviewer | `git show HEAD` | `jj show @-` | `arc show HEAD` |

In jj the working copy is a commit itself: after `jj commit` the new empty `@` collects fixes, and `jj diff` shows exactly the delta since A. Do not `jj new` mid-task.

## Task loop

1. Move the task to **In Progress** via the tracker workflow from `docs/agents/issue-tracker.md`.

2. **Implement.** Spawn a `general` subagent:
   > `/implement <TASK_ID>`
   >
   > Do NOT commit anything — leave all changes uncommitted in the working copy (this overrides the commit step in /implement; the orchestrator owns commits).

   Add only context that is missing from the tracker task itself. Keep the returned session handle — you will resume this same subagent for fixes.

3. **Review round 1.** Spawn a *different* `general` subagent (the reviewer):
   > `/code-review <TASK_ID>`
   >
   > Review ONLY the uncommitted working-copy changes. Use `<diff command from the VCS table>` instead of the `fixed-point...HEAD` range the skill describes. Classify every finding as **blocker** or **minor**.

   Keep the reviewer's session handle too.

4. **Commit A.** Create a *new* commit with message `<TASK_ID>: <task title>` (see VCS table). This commit now holds the reviewed implementation.

5. **No findings** → go to step 9. **Findings exist** → resume the implementer session with the findings verbatim and ask it to fix them, again without committing.

6. **Review round 2+.** Resume the reviewer session:
   > The implementer has addressed your findings. The uncommitted working copy (`<diff command>`) now contains ONLY the fixes for your findings — review that delta. The rest of the implementation is in commit A (`<show command from the VCS table>`); consult it for context, but findings must target the new delta. Classify every finding as **blocker** or **minor**.

7. **Amend.** Fold the fixes into commit A (see VCS table). The task must remain a single commit.

8. **Loop decision.**
   - Last review had **blockers** → back to step 5.
   - Only **minor** findings → have the implementer fix them, amend once more, no further review → step 9.
   - **No findings** → step 9.
   - **Guard:** if blockers are still found after the 3rd fix round, stop the loop and escalate to the user with the full history of findings for this task. Do not start the next task.

9. Move the task to **Done** in the tracker. If tasks remain in the epic, go to step 1. Otherwise the epic is complete — report a summary: one line per task with its commit.

## Rules

- Only the orchestrator runs VCS commands. Subagents never commit.
- Fix rounds resume the original implementer session; re-reviews resume the original reviewer session. Fresh sessions only per new task.
- Never copy the task description/spec into subagent prompts beyond the base `/implement <TASK_ID>` / `/code-review <TASK_ID>` request — pass only context the tracker task lacks.
