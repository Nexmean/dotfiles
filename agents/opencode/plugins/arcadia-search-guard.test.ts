import { afterAll, describe, expect, mock, test } from "bun:test";
import { mkdtempSync, rmSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import path from "node:path";

mock.module("@opencode-ai/plugin", () => {
  const string = () => {
    const schema = {
      describe: () => schema,
      optional: () => schema,
    };
    return schema;
  };
  return {
    tool: Object.assign((definition: unknown) => definition, {
      schema: { string },
    }),
  };
});

const {
  default: searchPlugin,
  isBroadArcadiaRoot,
  resolveSearchPath,
  runRipgrep,
  searchPathExists,
} = await import("./arcadia-search-guard");

const home = "/home/user";

describe("isBroadArcadiaRoot", () => {
  test.each([
    ["/home/user/arcadia", "/tmp", true],
    ["~/arcadia", "/tmp", true],
    [undefined, "/home/user/arcadia", true],
    ["/home/user/arcadias/1", "/tmp", true],
    ["~/arcadias", "/tmp", true],
    ["~", "/tmp", true],
    ["/home", "/tmp", true],
    ["/", "/tmp", true],
    ["devtools", "/home/user/arcadias/1", false],
    ["/home/user/arcadias/1/devtools", "/tmp", false],
    ["/home/user/projects", "/tmp", false],
  ])("path %s from %s is blocked: %s", (value, directory, blocked) => {
    expect(isBroadArcadiaRoot(value, directory, home)).toBe(blocked);
  });
});

describe("resolveSearchPath", () => {
  const root = mkdtempSync(path.join(tmpdir(), "arcadia-search-guard-"));
  const file = path.join(root, "file.txt");
  writeFileSync(file, "");

  afterAll(() => rmSync(root, { recursive: true }));

  test.each([
    [undefined, root, root],
    ["file.txt", root, file],
    [file, "/tmp", file],
    ["~/file.txt", "/tmp", file],
  ])("resolves %s from %s", (value, directory, expected) => {
    expect(resolveSearchPath(value, directory, root)).toBe(expected);
  });

  test("detects missing paths", () => {
    expect(searchPathExists("file.txt", root, root)).toBe(true);
    expect(searchPathExists("missing", root, root)).toBe(false);
  });
});

describe("runRipgrep", () => {
  test("fails only the process when its timeout expires", async () => {
    await expect(
      runRipgrep({
        command: process.execPath,
        args: ["-e", "await Bun.sleep(1000)"],
        cwd: "/tmp",
        label: "search",
        timeoutMs: 10,
        parse: () => undefined,
      }),
    ).rejects.toThrow("search timed out after 0.01 seconds");
  });

  test("the grep wrapper returns matches as a tool result", async () => {
    const root = mkdtempSync(path.join(tmpdir(), "grep-wrapper-"));
    const file = path.join(root, "match.txt");
    writeFileSync(file, "needle\n");
    try {
      const plugin = await searchPlugin({ directory: root } as never);
      const result = await plugin.tool!.grep.execute(
        { pattern: "needle", path: root },
        {
          sessionID: "session",
          messageID: "message",
          agent: "build",
          directory: root,
          worktree: root,
          abort: new AbortController().signal,
          metadata: () => {},
          ask: async () => {},
        },
      );
      expect(result).toMatchObject({
        metadata: { matches: 1, truncated: false },
      });
      expect(result.output).toContain(`${file}:`);
    } finally {
      rmSync(root, { recursive: true });
    }
  });
});
