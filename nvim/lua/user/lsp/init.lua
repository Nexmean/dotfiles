local utils = Config.common.utils
local notify = Config.common.notify
local pl = utils.pl
local config_store = {}

local M = {}
_G.Config.lsp = M

---@diagnostic disable-next-line: unused-local
function M.common_on_attach(client, bufnr)
  -- require("illuminate").on_attach(client)
  require("lsp_signature").on_attach({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    handler_opts = {
      border = "single",
    },
  }, bufnr)
end

function M.sequence_on_attach(...)
  local args = ...

  return function(client, bufnr)
    for _, on_attach in ipairs(args) do
      on_attach(client, bufnr)
    end
  end
end

function M.create_base_config()
  return {
    on_attach = M.common_on_attach,
    capabilities = utils.tbl_union_extend(
      vim.lsp.protocol.make_client_capabilities(),
      require("cmp_nvim_lsp").default_capabilities()
    ),
  }
end

M.local_config_paths = {
  ".vim/lsp_init.lua",
  ".vim/lsp_settings.lua",
  ".vim/lsprc.lua",
  ".lsprc.lua",
}

function M.create_local_config(config)
  local cwd = uv.cwd()
  local local_config = config_store[cwd]
  local project_config = Config.state.project_config
  config = config or {}

  if not local_config then
    if type(project_config) == "table" and project_config.lsp_config then
      local_config = project_config.lsp_config
      notify.config "Using LSP config from project config."
    else
      for _, path in ipairs(M.local_config_paths) do
        if pl:readable(path) then
          notify.config("Using project-local LSP config: " .. utils.str_quote(path))
          local code_chunk = loadfile(path)
          if code_chunk then
            local_config = code_chunk()
            break
          end
        end
      end
    end

    if not local_config then
      local_config = {}
    end

    config_store[cwd] = local_config
  end

  if vim.is_callable(local_config) then
    local_config = local_config(config)
  else
    local_config = utils.tbl_union_extend(config, local_config)
  end

  return local_config
end

---Create lsp config from base + server defaults + local config.
---@param ... table Set of LSP configs sorted by order of precedence: later
---configs will overwrite earlier configs.
---@return table
function M.create_config(...)
  local config = utils.tbl_union_extend(M.create_base_config(), {}, ...)

  return M.create_local_config(config)
end

function M.define_diagnostic_signs(opts)
  local group = {
    -- version 0.5
    {
      highlight = "LspDiagnosticsSignError",
      sign = opts.error,
    },
    {
      highlight = "LspDiagnosticsSignWarning",
      sign = opts.warn,
    },
    {
      highlight = "LspDiagnosticsSignHint",
      sign = opts.hint,
    },
    {
      highlight = "LspDiagnosticsSignInformation",
      sign = opts.info,
    },
    -- version >=0.6
    {
      highlight = "DiagnosticSignError",
      sign = opts.error,
    },
    {
      highlight = "DiagnosticSignWarn",
      sign = opts.warn,
    },
    {
      highlight = "DiagnosticSignHint",
      sign = opts.hint,
    },
    {
      highlight = "DiagnosticSignInfo",
      sign = opts.info,
    },
  }

  for _, g in ipairs(group) do
    vim.fn.sign_define(g.highlight, {
      text = g.sign,
      texthl = g.highlight,
      linehl = "",
      numhl = "",
    })
  end
end

-- Highlight references on cursor hold

function M.highlight_cursor_symbol()
  if vim.lsp.buf.server_ready() then
    if vim.fn.mode() ~= "i" then
      vim.lsp.buf.document_highlight()
    end
  end
end

function M.highlight_cursor_clear()
  if vim.lsp.buf.server_ready() then
    vim.lsp.buf.clear_references()
  end
end
---------------------------------

function M.show_position_diagnostics()
  vim.diagnostic.open_float { scope = "cursor", border = "single" }
end

return M
