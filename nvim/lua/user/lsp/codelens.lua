local api = vim.api
local namespaces = vim.lsp.codelens.__namespaces
local M = {}

--- Display the lenses using virtual text
---
---@param lenses table of lenses to display (`CodeLens[] | null`)
---@param bufnr number
---@param client_id number
function M.display(lenses, bufnr, client_id)
  local ns = namespaces[client_id]
  if not lenses or not next(lenses) then
    api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
    return
  end
  local lenses_by_lnum = {}
  for _, lens in pairs(lenses) do
    local line_lenses = lenses_by_lnum[lens.range.start.line]
    if not line_lenses then
      line_lenses = {}
      lenses_by_lnum[lens.range.start.line] = line_lenses
    end
    table.insert(line_lenses, lens)
  end
  local num_lines = api.nvim_buf_line_count(bufnr)
  for i = 0, num_lines do
    local line_lenses = lenses_by_lnum[i] or {}
    api.nvim_buf_clear_namespace(bufnr, ns, i, i + 1)
    local chunks = {}
    local num_line_lenses = #line_lenses
    table.sort(line_lenses, function(a, b)
      return a.range.start.character < b.range.start.character
    end)
    for j, lens in ipairs(line_lenses) do
      local text = lens.command and lens.command.title or "Unresolved lens ..."
      text = text:gsub("%s+", " ")
      table.insert(chunks, { text, "LspCodeLens" })
      if j < num_line_lenses then
        table.insert(chunks, { " | ", "LspCodeLensSeparator" })
      end
    end
    if #chunks > 0 then
      api.nvim_buf_set_extmark(bufnr, ns, i, 0, {
        virt_lines = { chunks },
        virt_lines_above = true,
        hl_mode = "combine",
      })
    end
  end
end

return M
