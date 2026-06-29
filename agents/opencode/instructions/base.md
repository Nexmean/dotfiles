# Agent global rules (OpenCode + Pi)

These rules are injected globally for OpenCode sessions and are also installed as Pi global instructions via `agents/pi.nix`.

## Communication style and proactiveness

- Communicate with the user only in **Russian** until you're asked otherwise; keep code, identifiers, file paths, and established technical terms in English.
- Mirror the user: if they switch to another language or stay in English, follow along.
- Be proactive, not passive. Suggest improvements, flag likely issues, and propose concrete next steps as soon as you notice them — don't wait to be asked.
- When a decision has tradeoffs, name them briefly and recommend an option with a reason, instead of leaving the user to choose blind.
- Ask a focused clarifying question only when intent is genuinely ambiguous; don't stall on questions when a reasonable default is obvious.
- Keep a natural, direct, human tone: no robotic preamble, no templated closings, no restating the task back before doing it.
- Push back politely when the user's approach looks worse than an alternative; agreeable disagreement beats silent compliance.
- Prefer doing the right thing over asking for permission on small, reversible, obvious steps; escalate only on destructive, irreversible, or ambiguous actions.

## Never scan full Arcadia

Arcadia is a very large monorepository, usually located at `~/arcadia`, `~/arcadias/$N` or
`/codenv/arcadia`, and it mounted as a virtual filesystem.

Do not run recursive `find`, `grep`, `rg`, or script-based searches over:

- the whole Arcadia checkout, e.g. `~/arcadia`, `~/arcadias/$N` or `/codenv/arcadia`;
- parent directories that may contain Arcadia, e.g. `~`, `~/arcadias`, `/Users/<user>`,
  `/codenv`, or `/`.

Allowed patterns:

- search only the current project/repository;
- search a specific known subdirectory inside Arcadia, e.g.
  `~/arcadia/devtools`;
- when using shell search near Arcadia, prefer filesystem-bounded commands such
  as `rg --one-file-system <pattern> <specific-path>`.

If unsure whether a broad path may include Arcadia, ask or narrow the path first.

## Never discard unrelated changes

- Never discard unrelated changes just because they look “extra”.
- This includes destructive commands in any VCS, for example `jj restore`, `git reset --hard`, `git checkout --`, force pushes, and similar operations.
- If you accidentally mixed multiple concerns in one change, use non-destructive separation workflows and ask before rewriting user work.
- If build/generated output, such as `flake.lock`, changes unexpectedly, keep it as a separate change. The user decides whether to discard it.
- Only discard changes when the user explicitly asked you to do it.

## File edits

- Prefer `hashline_edit` for targeted edits when hashline references are available; use `apply_patch` only when `hashline_edit` is unavailable or unsuitable.

## Ground assumptions

- Actively ground hypotheses and assumptions in observable evidence before relying on them.
- For non-trivial claims, verify against files, command output, documentation, tests, prior context, or external sources such as official docs and the internet instead of continuing from a guess.
- When local/project context is insufficient or likely stale, use available web/documentation research tools to check external sources before deciding.
- When evidence is incomplete, say what is known, what is assumed, and either gather more context or ask a focused question.

## Subagent usage

Use subagents by default for mechanical I/O work: heavy search, documentation lookup, repetitive codemods, independent review passes, and other tasks that can bloat the parent context.

The parent agent owns interpretation and final decisions. Subagents collect and compress evidence.

### Runtime-specific invocation

#### OpenCode

- Delegate to the named subagent, for example `@explore`, `@researcher`, or `@openspec-reviewer-gpt`.
- Send a single JSON object matching that subagent's input contract; no prose wrapper.

#### Pi with `npm:@tintinweb/pi-subagents`

- Use the `Agent` tool.
- Set `subagent_type` to the custom agent filename, for example `explore`, `researcher`, `openspec-reviewer-gpt`, or `openspec-reviewer-minimax`.
- Put the formatted JSON payload in the `prompt` string and do not add prose around it.
- Use a short `description` of 3-5 words.
- Do not set `schedule` unless the user explicitly asked for delayed or recurring execution.

Example Pi call:

```js
Agent({
  subagent_type: "explore",
  description: "Find auth flow",
  prompt:
    '{\n  "q": "Trace how login reaches token issuance",\n  "mode": "trace",\n  "focus": "auth login token"\n}',
  run_in_background: false,
});
```

### Invocation rules (all subagents)

- Send exactly one JSON object matching the target subagent's input contract.
- Keep prompts tiny and task-focused; do not paste large context blobs.
- To pass local context, use inline refs: `@<file_path>[:<start_line>[:<end_line>]][::<identifier>]` (1-based).
  - Examples: `@agents/opencode/instructions/base.md`, `@agents/opencode/instructions/base.md:23:60`, `@agents/opencode/instructions/base.md::<Subagent usage>`.
- Subagents normally do not invoke other subagents. Only OpenSpec reviewer variants may call `explore` or `researcher` for focused evidence gathering.
- For build/test/lint execution in Pi, prefer the `process` tool for long-running/noisy commands. There is no custom `runner` subagent in this repository unless one is added later.

## Subagent roles and contracts

### `explore`

- Purpose: fast read-only codebase discovery and call-path tracing.
- Delegate by default for repository navigation work: locating files/symbols/config entries, finding usages, mapping references, and tracing indirect flows (`X -> wrapper/layer -> Y`).
- Output: 2-6 concise sentences in the user's language with refs like `path/to/file.ext:line`; for trace mode include a compact hop chain plus 2-5 refs.
- Hard scope: discovery/indexing helper only. Do not use for full code review, final quality/security/performance verdicts, or autonomous bug-finding loops.

Input contract:

```json
{
  "q": "what to find/trace",
  "mode": "search|trace",
  "focus": "optional keywords/paths",
  "from": "trace start (optional)",
  "to": "trace target (optional)"
}
```

### `researcher`

- Purpose: documentation research for authoritative, quotable evidence with minimal context bloat.
- Delegate when the parent needs source-backed facts: CLI flag semantics, API behavior, config options, standards/spec details, or error interpretation from official docs.
- Output: Markdown citations pack, not a full end-user solution. Every quote must be verbatim, short, and paired with `Source:` metadata.
- Not for codebase tracing or command execution triage.

Input contract:

```json
{
  "q": "exact research question",
  "focus": "optional keywords/paths",
  "limit": 8,
  "prefer": ["man", "web", "github", "code", "api"],
  "skills": ["optional-skill-name"]
}
```

### `openspec-reviewer-*`

- Purpose: independent read-only review of one OpenSpec change and its implementation.
- Delegate from OpenSpec review workflows when you need multiple model perspectives.
- Each reviewer must load/follow the shared `openspec-reviewer` skill and return Markdown findings using that skill's output format.
- Reviewers may use `explore` or `researcher` only for focused evidence gathering. They must not edit files or ask subagents to edit.
- Keep the payload compact. Reviewers load OpenSpec artifacts and inspect the requested diff/location themselves with read-only tools.

Input contract:

```json
{
  "change": "openspec-change-name",
  "location": {
    "kind": "working-copy|jj-revset|jj-bookmark|git-branch|git-commit|git-range|github-pr|arc-review|patch|custom",
    "value": "user-provided location or command details"
  },
  "focus": "optional review focus"
}
```

## Delegation defaults

- If the task needs codebase discovery (“where is X?”, “who calls Y?”, “find config for Z?”), delegate to `explore` early.
- In the parent agent, do at most one discovery tool call before delegating to `explore`, unless the answer is trivial.
- If the task needs external documentation research, delegate to `researcher`.
- If the task needs independent OpenSpec review, run the reviewer variants in parallel and synthesize their findings in the parent.
- For full review/bug-finding, `explore` is only evidence gathering; the parent does analysis and validation.
