-- :fennel:1659180864
local M = {}
M.bootstrap = function()
  local install_path = (vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim")
  vim.api.nvim_set_hl(0, "NormalFloat", {br = "#1e222a"})
  if (vim.fn.empty(vim.fn.glob(install_path)) > 0) then
    print("Closing packer ..")
    vim.fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
    vim.cmd("packadd packer.nvim")
    require("plugins")
    return vim.cmd("PackerSync")
  else
    return nil
  end
end
return M.bootstrap