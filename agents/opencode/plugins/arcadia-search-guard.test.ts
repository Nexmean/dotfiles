import { describe, expect, test } from "bun:test";
import { isBroadArcadiaRoot } from "./arcadia-search-guard";

const home = "/home/user";

describe("isBroadArcadiaRoot", () => {
  test.each([
    ["/home/user/arcadia", "/tmp", true],
    ["~/arcadia", "/tmp", true],
    [undefined, "/home/user/arcadia", true],
    ["/home/user/arcadias/1", "/tmp", true],
    ["devtools", "/home/user/arcadias/1", false],
    ["/home/user/arcadias/1/devtools", "/tmp", false],
    ["/home/user/arcadias", "/tmp", false],
  ])("path %s from %s is blocked: %s", (value, directory, blocked) => {
    expect(isBroadArcadiaRoot(value, directory, home)).toBe(blocked);
  });
});
