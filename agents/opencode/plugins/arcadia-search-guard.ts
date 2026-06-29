import type { Plugin } from "@opencode-ai/plugin";
import { homedir } from "node:os";
import path from "node:path";

export function isBroadArcadiaRoot(
  value: unknown,
  directory: string,
  home = homedir(),
) {
  const raw = typeof value === "string" ? value : ".";
  const target = path.resolve(
    directory,
    raw.startsWith("~/") ? path.join(home, raw.slice(2)) : raw,
  );
  if (target === path.join(home, "arcadia")) return true;

  const checkout = path.relative(path.join(home, "arcadias"), target);
  return (
    checkout !== "" &&
    checkout !== ".." &&
    !checkout.startsWith(`..${path.sep}`) &&
    !checkout.includes(path.sep)
  );
}

export default (async ({ directory }) => ({
  "tool.execute.before": async (input, output) => {
    if (
      !["glob", "grep"].includes(input.tool) ||
      !isBroadArcadiaRoot(output.args.path, directory)
    )
      return;

    throw new Error(
      `Broad ${input.tool} at an Arcadia checkout root is disabled. Use ya grep, or narrow path to a child directory.`,
    );
  },
})) satisfies Plugin;
