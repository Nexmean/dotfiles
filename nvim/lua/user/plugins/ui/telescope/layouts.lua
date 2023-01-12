local M = {}

local resolve = require "telescope.config.resolve"
local p_window = require "telescope.pickers.window"

local get_border_size = function(opts)
  if opts.window.border == false then
    return 0
  end

  return 1
end

local calc_tabline = function(max_lines)
  local tbln = (vim.o.showtabline == 2)
    or (vim.o.showtabline == 1 and #vim.api.nvim_list_tabpages() > 1)
  if tbln then
    max_lines = max_lines - 1
  end
  return max_lines, tbln
end

local calc_size_and_spacing = function(cur_size, max_size, bs, w_num, b_num, s_num)
  local spacing = s_num * (1 - bs) + b_num * bs
  cur_size = math.min(cur_size, max_size)
  cur_size = math.max(cur_size, w_num + spacing)
  return cur_size, spacing
end

local adjust_pos = function(pos, ...)
  for _, opts in ipairs { ... } do
    opts.col = opts.col and opts.col + pos[1]
    opts.line = opts.line and opts.line + pos[2]
  end
end

local function horizontal_collapsed(self, max_columns, max_lines, override_layout)
  local layout_config = vim.tbl_deep_extend(
    "keep",
    vim.F.if_nil(override_layout, {}),
    vim.F.if_nil(self.layout_config, {})
  )

  local initial_options = p_window.get_initial_window_options(self)
  local preview = initial_options.preview
  local results = initial_options.results
  local prompt = initial_options.prompt

  local tbln
  max_lines, tbln = calc_tabline(max_lines)

  local width_opt = layout_config.width
  local width = resolve.resolve_width(width_opt)(self, max_columns, max_lines)

  local height_opt = layout_config.height
  local height = resolve.resolve_height(height_opt)(self, max_columns, max_lines)

  local bs = get_border_size(self)

  local w_space
  if self.previewer and max_columns >= layout_config.preview_cutoff then
    -- Cap over/undersized width (with previewer)
    width, w_space = calc_size_and_spacing(width, max_columns, bs, 2, 4, 1)

    preview.width =
      resolve.resolve_width(vim.F.if_nil(layout_config.preview_width, function(_, cols)
        if cols < 150 then
          return math.floor(cols * 0.4)
        elseif cols < 200 then
          return 80
        else
          return 120
        end
      end))(self, width, max_lines)

    results.width = width - preview.width - w_space
    prompt.width = results.width
  else
    -- Cap over/undersized width (without previewer)
    width, w_space = calc_size_and_spacing(width, max_columns, bs, 1, 2, 0)

    preview.width = 0
    results.width = width - preview.width - w_space
    prompt.width = results.width
  end

  local h_space
  -- Cap over/undersized height
  height, h_space = calc_size_and_spacing(height, max_lines, bs, 2, 4, 1)

  prompt.height = 1
  results.height = height - prompt.height - h_space + 1

  if self.previewer then
    preview.height = height - 2 * bs
  else
    preview.height = 0
  end

  local width_padding = math.floor((max_columns - width) / 2)
  results.col = width_padding + bs + 1
  prompt.col = results.col
  preview.col = results.col + results.width + 1 + bs

  preview.line = math.floor((max_lines - height) / 2) + bs + 1
  prompt.line = preview.line
  results.line = prompt.line + prompt.height + bs

  local anchor_pos =
    resolve.resolve_anchor_pos(layout_config.anchor or "", width, height, max_columns, max_lines)
  adjust_pos(anchor_pos, prompt, results, preview)

  if tbln then
    prompt.line = prompt.line + 1
    results.line = results.line + 1
    preview.line = preview.line + 1
  end

  return {
    preview = self.previewer and preview.width > 0 and preview,
    results = results,
    prompt = prompt,
  }
end

local horizontal_collapsed_options = {
  width = { "How wide to make Telescope's entire layout", "See |resolver.resolve_width()|" },
  height = { "How tall to make Telescope's entire layout", "See |resolver.resolve_height()|" },
  scroll_speed = "The number of lines to scroll through the previewer",
  anchor = { "Which edge/corner to pin the picker to", "See |resolver.resolve_anchor_pos()|" },
  preview_width = {
    "Change the width of Telescope's preview window",
    "See |resolver.resolve_width()|",
  },
  preview_cutoff = "When columns are less than this value, the preview will be disabled",
}

function M.setup(default_layout_config)
  local strategies = require "telescope.pickers.layout_strategies"
  strategies._configurations["horizontal_collapsed"] = horizontal_collapsed_options
  strategies["horizontal_collapsed"] = function(self, max_columns, max_lines, override_layout)
    return horizontal_collapsed(
      self,
      max_columns,
      max_lines,
      vim.tbl_deep_extend(
        "keep",
        vim.F.if_nil(override_layout, {}),
        default_layout_config.horizontal_collapsed
      )
    )
  end
end

return M
