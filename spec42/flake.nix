{
  description = "Spec42 CLI, language server, and MCP server";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    in
    {
      packages = nixpkgs.lib.genAttrs systems (
        system:
        let
          spec42 = nixpkgs.legacyPackages.${system}.callPackage ./package.nix { };
        in
        {
          default = spec42;
          inherit spec42;
        }
      );
    };
}
