{lib, ...}: {
  plugins.lazydev = {
    enable = true;
    settings.enabled = lib.nixvim.mkRaw ''
      function(root_dir)
        return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
      end
    '';
  };
}
