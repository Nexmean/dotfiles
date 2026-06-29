---
description: Review code changes, plans, live pages, or local HTML with Crit inline comments
agent: build
---

# Review With Crit

Review and revise code changes, a plan, a live page, or a local HTML file using `crit` for inline comment review.

If the `crit` skill is available, load it first.

## Step 1: Determine Review Mode

Pick whichever applies without asking for confirmation:

1. `$ARGUMENTS` provided, for example `/crit plan.md`: run `crit $ARGUMENTS`.
2. No argument, but a plan file was written earlier in this conversation: run `crit <plan-file>`.
3. User asked to review a GitHub PR or commit range: run `crit --pr <num-or-url>` or `crit --range <base>..<head>`.
4. Otherwise: run bare `crit` for the current branch or working tree.

## Step 2: Launch Crit And Block

Run `crit` in the foreground and wait until it exits:

```bash
crit <arguments>
crit
```

When `crit` prints the review URL, relay it verbatim and tell the user to leave inline comments and click Finish Review.

Do not proceed until `crit` completes. Do not read the review file early.

## Step 3: Read Review Output

When `crit` completes, read stdout and follow its instructions. Check stderr for `approved: true` or `approved: false`.

For unresolved comments:

1. Treat `quote` as the precise selected text to address.
2. Use `anchor` to locate moved content instead of trusting stale line numbers.
3. Treat `drifted: true` line numbers as approximate.
4. Read existing `replies` before acting.

## Step 4: Address Comments

For each unresolved comment:

1. Understand the requested change.
2. Apply any explicit suggestion block when present.
3. Revise the referenced file.
4. Reply with `crit comment --reply-to <id> --author 'OpenCode' '<what changed>'`.
5. Do not pass `--resolve` unless the user explicitly asks.

For three or more replies, prefer one bulk JSON call:

```bash
crit comment --json --file /tmp/crit-replies.json --author 'OpenCode'
```

## Step 5: Start The Next Round

Run the follow-up command from `crit` stdout to signal completion and start the next round.

Tell the user: "Changes applied. Review the diff in your browser and click Finish Review when ready."

Wait for `crit` to complete again, then return to Step 3. Stop when the review has no unresolved comments.
