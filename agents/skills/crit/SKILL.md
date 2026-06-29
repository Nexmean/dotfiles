---
name: crit
description: "Review code changes, a plan, a live page, or a local HTML file with Crit inline comments. Use when asked to review code, a plan, a diff, a running web app, or when structured human feedback is needed. Also covers programmatic comment authoring, Crit sharing, GitHub PR sync, and review file interpretation."
compatibility: opencode
---

## What I Do

- Launch Crit for a plan file, current code changes, a live page, or a local HTML file.
- Wait for the user to review changes in the browser.
- Read the review output and address unresolved inline comments.
- Signal the next review round with `crit` after edits are done.
- Leave inline review comments programmatically with `crit comment`.
- Sync reviews with GitHub PRs via `crit pull` and `crit push`.

## Launching `crit`

The CLI auto-detects review mode from its arguments. Do not ask the user which mode to use. Pass arguments through:

```bash
crit <arguments>               # file, dir, URL, .html
crit --pr <num-or-url>         # GitHub PR range mode
crit --range <base>..<head>    # commit range mode
crit                           # no args: branch or working tree diff
```

If no arguments are provided, check conversation context:

1. A plan file was written earlier in this conversation: run `crit <plan-file>`.
2. Otherwise: run bare `crit`.

## Review Loop

Run `crit` in the foreground and block until it exits. When it prints a URL, relay it verbatim and tell the user to leave inline comments and click Finish Review.

Do not proceed until `crit` completes. Do not ask the user to type anything. Do not read the review file early.

When `crit` completes, read stdout and follow its instructions. Check stderr for `approved: true` or `approved: false`.

For each unresolved comment:

1. Understand what the comment asks for.
2. Apply explicit suggestion blocks when present.
3. Revise the referenced plan or code file.
4. Reply with `crit comment --reply-to <id> --author 'OpenCode' '<what changed>'`.
5. Do not pass `--resolve` unless the user explicitly asks.

Run the follow-up command from stdout to signal completion and start the next round. Wait again until the user finishes review. Stop when there are no unresolved comments.

## Comment Fields

- `resolved: false` or missing means unresolved. Only `true` means resolved.
- `quote` narrows the scope to selected text within the line range.
- `anchor` captures the original commented text; use it when line numbers drift.
- `drifted: true` means the original content was removed or heavily rewritten, so line numbers are approximate.
- `replies` may contain useful prior context; read them before acting.

## Programmatic Comments

Always pass `--author 'OpenCode'` so comments are attributed correctly.

```bash
crit comment --author 'OpenCode' '<body>'
crit comment --author 'OpenCode' <path> '<body>'
crit comment --author 'OpenCode' <path>:<line> '<body>'
crit comment --author 'OpenCode' <path>:<start>-<end> '<body>'
crit comment --reply-to <id> --author 'OpenCode' '<body>'
```

Line numbers reference the file on disk, not diff line numbers. Reply bodies support markdown. Only pass `--resolve` when the user explicitly asks.

When leaving three or more comments or replies, use one bulk JSON call:

```bash
crit comment --json --file /tmp/crit-bulk.json --author 'OpenCode'
```

Per-entry fields include `file` or `path`, `line`, `end_line`, `body`, `author`, `scope`, `reply_to`, and `resolve`. In JSON mode, `resolve` follows the same explicit-user-request rule.

If `crit comment` reports an ID collision across files, disambiguate replies with `--path <file>` or set the entry `file` field in JSON mode.

## Plan Mode

Plan reviews may store review data under `~/.crit/plans/<slug>/`. When a plan slug is shown in Crit output, pass it back with comment commands:

```bash
crit comment --plan <slug> --reply-to <id> --author 'OpenCode' '<body>'
```

## GitHub PR Sync

```bash
crit pull [pr-number]
crit push [--dry-run] [--event <type>] [-m <msg>] [pr-number]
```

This requires `gh` installed and authenticated. `--event` may be `comment`, `approve`, or `request-changes`.

## Sharing

If the user asks for a URL, shareable link, or QR code:

```bash
crit share <file> [file...]
crit share --qr <file>
crit unpublish [file...]
```

Always relay the output, including the URL, directly to the user. Use `--qr` only in terminal environments where Unicode block characters render correctly.
