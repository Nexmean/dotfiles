let
  pkgs = import <nixpkgs> {}
in
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      cabal-install
      ghc
    ]
  }
