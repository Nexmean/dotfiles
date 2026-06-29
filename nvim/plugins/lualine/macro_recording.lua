local M = {}

local uv = vim.uv or vim.loop

local levels = {
  1.00,
  0.96,
  0.85,
  0.69,
  0.50,
  0.31,
  0.15,
  0.04,
  0.00,
  0.04,
  0.15,
  0.31,
  0.50,
  0.69,
  0.85,
  0.96,
}

local backgrounds = {
  normal = { "lualine_x_normal", "lualine_c_normal", "StatusLine", "Normal" },
  insert = { "lualine_x_insert", "lualine_x_normal", "StatusLine", "Normal" },
  visual = { "lualine_x_visual", "lualine_x_normal", "StatusLine", "Normal" },
  replace = { "lualine_x_replace", "lualine_x_normal", "StatusLine", "Normal" },
  command = { "lualine_x_command", "lualine_x_normal", "StatusLine", "Normal" },
  terminal = { "lualine_x_terminal", "lualine_x_insert", "lualine_x_normal", "StatusLine", "Normal" },
}

local timer = nil
local frame = 1

local function safe_refresh_lualine()
  pcall(require("lualine").refresh)
end

local function get_hl_attr(names, attr)
  for _, name in ipairs(names) do
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name })
    if ok and hl and hl[attr] then
      return hl[attr]
    end
  end
end

local function mix(a, b, t)
  return math.floor(a + (b - a) * t + 0.5)
end

local function blend(c1, c2, t)
  return {
    r = mix(bit.rshift(c1, 16) % 256, bit.rshift(c2, 16) % 256, t),
    g = mix(bit.rshift(c1, 8) % 256, bit.rshift(c2, 8) % 256, t),
    b = mix(c1 % 256, c2 % 256, t),
  }
end

local function set_highlights()
  local fg = get_hl_attr({ "@error", "DiagnosticError", "ErrorMsg" }, "fg") or 0xff0000
  for mode, bg_groups in pairs(backgrounds) do
    local bg = get_hl_attr(bg_groups, "bg") or 0x000000
    for i, level in ipairs(levels) do
      local color = blend(bg, fg, level)
      local hex = string.format("#%02x%02x%02x", color.r, color.g, color.b)
      pcall(vim.api.nvim_set_hl, 0, "LualineMacroRecording_" .. mode .. "_" .. i, { fg = hex, bg = bg })
    end
  end
end

local function current_mode()
  local mode = vim.fn.mode(1)
  local first = mode:sub(1, 1)
  local first_byte = mode:byte(1)
  if first == "i" then
    return "insert"
  end
  if first == "v" or first == "V" or first_byte == 22 then
    return "visual"
  end
  if first == "R" then
    return "replace"
  end
  if first == "c" or first == "!" then
    return "command"
  end
  if first == "t" then
    return "terminal"
  end
  return "normal"
end

local function current_group()
  if frame < 1 or frame > #levels then
    frame = 1
  end
  return "LualineMacroRecording_" .. current_mode() .. "_" .. frame
end

local function stop_animation()
  if timer then
    timer:stop()
    timer:close()
    timer = nil
  end
  frame = 1
end

local function start_animation()
  stop_animation()
  set_highlights()
  safe_refresh_lualine()

  if not uv or not uv.new_timer then
    return
  end

  local next_timer = uv.new_timer()
  if not next_timer then
    return
  end

  timer = next_timer
  next_timer:start(80, 80, function()
    vim.schedule(function()
      if timer ~= next_timer then
        return
      end

      frame = frame + 1
      if frame > #levels then
        frame = 1
      end
      safe_refresh_lualine()
    end)
  end)
end

function M.component()
  local reg = vim.fn.reg_recording()
  if reg == "" then
    return ""
  end
  return "%#" .. current_group() .. "#󰑋%* " .. reg
end

function M.setup()
  if vim.g.__lualine_macro_recording_setup_done then
    set_highlights()
    return
  end
  vim.g.__lualine_macro_recording_setup_done = true

  local group = vim.api.nvim_create_augroup("LualineMacroRecording", { clear = true })

  vim.api.nvim_create_autocmd("RecordingEnter", {
    group = group,
    callback = start_animation,
  })

  vim.api.nvim_create_autocmd("RecordingLeave", {
    group = group,
    callback = function()
      stop_animation()
      -- reg_recording() clears slightly after the event.
      vim.defer_fn(safe_refresh_lualine, 50)
    end,
  })

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = set_highlights,
  })

  set_highlights()
end

return M
