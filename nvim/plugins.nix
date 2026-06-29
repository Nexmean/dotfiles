{ ... }:
{
  imports = [
    ./plugins/scrollbar.nix
    ./plugins/vcsigns.nix

    ./plugins/auto-save.nix
    ./plugins/origami.nix
    ./plugins/treesitter.nix
    ./plugins/lsp.nix
    ./plugins/blink-cmp.nix
    ./plugins/which-key.nix
    ./plugins/noice.nix
    ./plugins/notify.nix

    ./plugins/trouble.nix

    ./plugins/overseer.nix

    ./plugins/icons.nix
    ./plugins/mini-pairs.nix
    ./plugins/mini-ai.nix
    ./plugins/mini-diff.nix
    ./plugins/mini-surround.nix

    ./plugins/leap.nix
    ./plugins/hunk.nix
    ./plugins/grug-far.nix
    ./plugins/snacks.nix
    ./plugins/seeker.nix
    ./plugins/render-markdown.nix

    ./plugins/haskell.nix
    ./plugins/rustaceanvim.nix
    ./plugins/likec4.nix

    ./plugins/repeat.nix
    ./plugins/auto-session.nix
    ./plugins/yanky.nix

    ./plugins/cursortab.nix
    ./plugins/direnv.nix
    ./plugins/langmapper.nix
    ./plugins/lualine.nix
    ./plugins/tabby.nix
    ./plugins/zoxide.nix

    ./plugins/quickfix.nix
    ./plugins/sidekick.nix

    # opencode.nvim frontend disabled; standalone opencode CLI remains configured elsewhere.
    # ./plugins/opencode/provider-sudo-tee.nix
    # ./plugins/opencode/provider-nickvandyke.nix
    ./plugins/dropbar.nix
    ./plugins/tabterm.nix
    ./plugins/vim-maximizer.nix
    ./plugins/herdr-navigation.nix
    ./plugins/lazydev.nix
  ];
}
