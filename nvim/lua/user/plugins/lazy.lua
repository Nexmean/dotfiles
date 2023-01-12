local M = {}

M.plugins = {}

M.opts = {
  ui = {
    border = "single",
  },
}

function M.register_plugin(p, prefix)
  if type(p) == "string" then
    if prefix ~= nil then
      table.insert(M.plugins, require(string.format("user.plugins.%s.%s", prefix, p)))
    else
      table.insert(M.plugins, require(string.format("user.plugins.%s", p)))
    end
  elseif type(p) == "table" then
    table.insert(M.plugins, p)
  else
    vim.notify(
      string.format("Unexpected register_plugin arg: %s", vim.inspect(p)),
      vim.log.levels.ERROR
    )
  end
end

function M.register_plugins(ps)
  local prefix
  if type(ps) == "string" then
    prefix = ps
    ps = require(string.format("user.plugins.%s", ps))
  elseif type(ps) ~= "table" then
    vim.notify(
      string.format("Unexpected register_plugins arg: %s", vim.inspect(ps)),
      vim.log.levels.ERROR
    )
  end

  for _, p in ipairs(ps) do
    M.register_plugin(p, prefix)
  end
end

function M.setup()
  require("lazy").setup(M.plugins, M.opts)
end

return M
