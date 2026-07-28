import { tool, type Plugin, type ToolContext } from "@opencode-ai/plugin";
import { spawn } from "node:child_process";
import { existsSync, statSync } from "node:fs";
import { homedir } from "node:os";
import path from "node:path";
import { createInterface } from "node:readline";

const SEARCH_TIMEOUT_MS = 10_000;
const RESULT_LIMIT = 100;

export async function runRipgrep<T>({
  args,
  cwd,
  label,
  parse,
  signal: parentSignal,
  timeoutMs = SEARCH_TIMEOUT_MS,
  command = "rg",
}: {
  args: string[];
  cwd: string;
  label: string;
  parse: (line: string) => T | undefined;
  signal?: AbortSignal;
  timeoutMs?: number;
  command?: string;
}) {
  const timeout = AbortSignal.timeout(timeoutMs);
  const signal = parentSignal
    ? AbortSignal.any([parentSignal, timeout])
    : timeout;
  const child = spawn(command, args, {
    cwd,
    signal,
    stdio: ["ignore", "pipe", "pipe"],
  });
  let processError: Error | undefined;
  let stderr = "";
  child.on("error", (error) => {
    processError = error;
  });
  child.stderr.setEncoding("utf8");
  child.stderr.on("data", (chunk: string) => {
    if (stderr.length < 8192) stderr += chunk;
  });
  const closed = new Promise<{ code: number | null }>((resolve) => {
    child.once("close", (code) => resolve({ code }));
  });

  const items: T[] = [];
  let truncated = false;
  for await (const line of createInterface({ input: child.stdout })) {
    const item = parse(line);
    if (item === undefined) continue;
    items.push(item);
    if (items.length <= RESULT_LIMIT) continue;
    truncated = true;
    child.kill();
    break;
  }

  const { code } = await closed;
  if (timeout.aborted) {
    throw new Error(`${label} timed out after ${timeoutMs / 1000} seconds`);
  }
  if (parentSignal?.aborted)
    throw processError ?? new Error(`${label} aborted`);
  if (processError) throw processError;
  if (!truncated && code !== 0 && code !== 1 && code !== 2) {
    throw new Error(stderr.trim() || `${label} failed with code ${code}`);
  }
  if (code === 2 && /regex parse error|error parsing regex/.test(stderr)) {
    throw new Error(stderr.trim());
  }

  return {
    items: code === 1 ? [] : items.slice(0, RESULT_LIMIT),
    truncated,
  };
}

export function resolveSearchPath(
  value: unknown,
  directory: string,
  home = homedir(),
) {
  const raw = typeof value === "string" ? value : ".";
  return path.resolve(
    directory,
    raw === "~"
      ? home
      : raw.startsWith("~/")
        ? path.join(home, raw.slice(2))
        : raw,
  );
}

export function searchPathExists(
  value: unknown,
  directory: string,
  home = homedir(),
) {
  return existsSync(resolveSearchPath(value, directory, home));
}

export function isBroadArcadiaRoot(
  value: unknown,
  directory: string,
  home = homedir(),
) {
  const target = resolveSearchPath(value, directory, home);
  const contains = (child: string) => {
    const relative = path.relative(target, child);
    return (
      relative === "" ||
      (relative !== ".." &&
        !relative.startsWith(`..${path.sep}`) &&
        !path.isAbsolute(relative))
    );
  };

  if (contains(path.join(home, "arcadia"))) return true;

  const checkout = path.relative(path.join(home, "arcadias"), target);
  return (
    contains(path.join(home, "arcadias")) ||
    (checkout !== "" &&
      checkout !== ".." &&
      !checkout.startsWith(`..${path.sep}`) &&
      !checkout.includes(path.sep))
  );
}

function contains(root: string, target: string) {
  const relative = path.relative(root, target);
  return (
    relative === "" ||
    (relative !== ".." &&
      !relative.startsWith(`..${path.sep}`) &&
      !path.isAbsolute(relative))
  );
}

async function askSearchPermission(
  context: ToolContext,
  toolName: "glob" | "grep",
  pattern: string,
  target: string,
  metadata: Record<string, unknown>,
  kind: "file" | "directory",
) {
  await context.ask({
    permission: toolName,
    patterns: [pattern],
    always: ["*"],
    metadata,
  });
  if (
    contains(context.directory, target) ||
    (context.worktree !== "/" && contains(context.worktree, target))
  )
    return;

  const directory = kind === "directory" ? target : path.dirname(target);
  const permissionPath = path.join(directory, "*").replaceAll("\\", "/");
  await context.ask({
    permission: "external_directory",
    patterns: [permissionPath],
    always: [permissionPath],
    metadata: { filepath: target, parentDir: directory },
  });
}

type GrepMatch = {
  path: string;
  line: number;
  text: string;
};

const globTool = tool({
  description: "Find files matching a glob pattern.",
  args: {
    pattern: tool.schema
      .string()
      .describe("The glob pattern to match files against"),
    path: tool.schema
      .string()
      .optional()
      .describe(
        "The directory to search in. Defaults to the current working directory.",
      ),
  },
  async execute(args, context) {
    const target = resolveSearchPath(args.path, context.directory);
    if (!statSync(target).isDirectory()) {
      throw new Error(`glob path must be a directory: ${target}`);
    }
    await askSearchPermission(
      context,
      "glob",
      args.pattern,
      target,
      args,
      "directory",
    );
    const result = await runRipgrep({
      args: [
        "--no-config",
        "--files",
        `--glob=${args.pattern}`,
        "--glob=!**/.git/**",
        ".",
      ],
      cwd: target,
      label: "glob",
      parse: (line) => line.replace(/^(?:\.[\\/])+/u, ""),
      signal: context.abort,
    });
    const output = result.items.map((file) => path.resolve(target, file));
    if (result.truncated) {
      output.push(
        "",
        `(Results are truncated: showing first ${RESULT_LIMIT} results. Consider using a more specific path or pattern.)`,
      );
    }
    return {
      title: path.relative(context.worktree, target),
      metadata: { count: result.items.length, truncated: result.truncated },
      output: output.join("\n") || "No files found",
    };
  },
});

const grepTool = tool({
  description: "Search file contents using a regular expression.",
  args: {
    pattern: tool.schema.string().describe("The regex pattern to search for"),
    path: tool.schema
      .string()
      .optional()
      .describe(
        "The file or directory to search. Defaults to the current working directory.",
      ),
    include: tool.schema
      .string()
      .optional()
      .describe('File pattern to include, for example "*.ts"'),
  },
  async execute(args, context) {
    const target = resolveSearchPath(args.path, context.directory);
    const isDirectory = statSync(target).isDirectory();
    await askSearchPermission(
      context,
      "grep",
      args.pattern,
      target,
      args,
      isDirectory ? "directory" : "file",
    );
    const cwd = isDirectory ? target : path.dirname(target);
    const result = await runRipgrep<GrepMatch>({
      args: [
        "--no-config",
        "--json",
        "--hidden",
        "--no-messages",
        ...(args.include ? [`--glob=${args.include}`] : []),
        "--glob=!**/.git/**",
        "--",
        args.pattern,
        isDirectory ? "." : path.basename(target),
      ],
      cwd,
      label: "grep",
      parse: (line) => {
        const item = JSON.parse(line);
        if (item.type !== "match") return;
        return {
          path: path.resolve(cwd, item.data.path.text),
          line: item.data.line_number,
          text: item.data.lines.text.trimEnd(),
        };
      },
      signal: context.abort,
    });
    if (result.items.length === 0) {
      return {
        title: args.pattern,
        metadata: { matches: 0, truncated: false },
        output: "No files found",
      };
    }

    const output = [
      `Found ${result.items.length} matches${result.truncated ? " (more matches available)" : ""}`,
    ];
    let current = "";
    for (const match of result.items) {
      if (match.path !== current) {
        if (current) output.push("");
        current = match.path;
        output.push(`${match.path}:`);
      }
      output.push(`  Line ${match.line}: ${match.text}`);
    }
    if (result.truncated) {
      output.push(
        "",
        "(Results truncated. Consider using a more specific path or pattern.)",
      );
    }
    return {
      title: args.pattern,
      metadata: {
        matches: result.items.length,
        truncated: result.truncated,
      },
      output: output.join("\n"),
    };
  },
});

export default (async ({ directory }) => ({
  tool: { glob: globTool, grep: grepTool },
  "tool.execute.before": async (input, output) => {
    if (!["glob", "grep"].includes(input.tool)) return;

    const target = resolveSearchPath(output.args.path, directory);
    if (!searchPathExists(output.args.path, directory)) {
      throw new Error(`${input.tool} path does not exist: ${target}`);
    }

    if (!isBroadArcadiaRoot(output.args.path, directory)) return;
    throw new Error(
      `Broad ${input.tool} over Arcadia or a parent directory is disabled. Use ya grep, or narrow path to a child directory.`,
    );
  },
})) satisfies Plugin;
