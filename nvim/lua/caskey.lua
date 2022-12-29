local M = {}

local opt_keys = {
  "act",
  "buf_local",
  "buf_local_extend",
  "desc",
  "expr",
  "mode",
  "mode_extend",
  "name",
  "noremap",
  "nowait",
  "silent",
}

local empty_global_wk = {
  n = {},
  v = {},
  s = {},
  x = {},
  o = {},
  i = {},
  l = {},
  c = {},
  t = {},
  ["!"] = {},
}

local function tbl_concat(t)
  local res = {}
  for _, tt in ipairs(t) do
    for _, v in ipairs(tt) do
      res[#res+1] = v
    end
  end

  return res
end

local function fill_wk(global_wk, config, prefix, parent_opts, parent_buf_local)
  parent_opts = parent_opts or {}
  prefix = prefix or ""

  local opts = {
    mode = vim.tbl_flatten {
      config.mode or parent_opts.mode or {},
      config.mode_extend or {},
    },
    noremap = vim.F.if_nil(config.noremap, parent_opts.noremap),
    silent = vim.F.if_nil(config.silent, parent_opts.silent),
    nowait = vim.F.if_nil(config.nowait, parent_opts.nowait),
    expr = vim.F.if_nil(config.expr, parent_opts.expr),
  }

  local buf_local = tbl_concat {
    vim.F.if_nil(vim.F.if_nil(config.buf_local, parent_buf_local), {}),
    vim.F.if_nil(config.buf_local_extend, {}),
  }

  local acts = {}

  if config.act ~= nil or config.name ~= nil then
    for _, mode in ipairs(opts.mode) do
      acts[mode] = {}
    end
  end

  if config.name ~= nil then
    for _, mode in ipairs(opts.mode) do
      acts[mode].name = config.name
    end
  end

  if config.act ~= nil then
    if type(config.act) == "string" or type(config.act) == "function" then
      for _, mode in ipairs(opts.mode) do
        acts[mode] = vim.tbl_extend(
          "keep",
          {config.act, config.desc},
          acts[mode],
          opts
        )
      end
    elseif type(config.act) == "table" then
      for mode, act in pairs(config.act) do
        acts[mode] = vim.tbl_extend(
          "keep",
          {act, config.desc},
          acts[mode],
          opts
        )
      end
    end
  end

  if #buf_local > 0 then
    for _, buf_local_conf in ipairs(buf_local) do
      vim.api.nvim_create_autocmd(buf_local_conf.event, {
        pattern = buf_local_conf.pattern,
        callback = function (e)
          local reqister_bindings = function ()
            local wk = require("which-key")
            for mode, act in pairs(acts) do
              wk.register(
                { [prefix] = vim.tbl_extend("force", {buffer = e.buf}, act) },
                { mode = mode }
              )
            end
          end
          if buf_local_conf.condition ~= nil then
            if buf_local_conf.condition(e) then
              reqister_bindings()
            end
          else
            reqister_bindings()
          end
        end
      })
    end
  else
    for mode, act in pairs(acts) do
      global_wk[mode][prefix] = act
    end
  end

  for k, c in pairs(config) do
    if type(k) == "string" and not vim.tbl_contains(opt_keys, k) then
      fill_wk(global_wk, c, prefix .. k, opts, buf_local)
    elseif type(k) == "number" then
      fill_wk(global_wk, c, prefix, opts, buf_local)
    end
  end

  return global_wk
end

function M.register(config)
  local global_wk = vim.tbl_deep_extend("force", empty_global_wk, {})
  fill_wk(global_wk, config)
  local wk = require("which-key")
  for mode, acts in pairs(global_wk) do
    wk.register(acts, { mode = mode })
  end
end

return M
