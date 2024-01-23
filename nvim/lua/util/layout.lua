local M = {}

local mac_os_us = [["U.S.";]] .. "\n"
local mac_os_ru = [[RussianWin;]] .. "\n"

M.mac_os_layout_map = {
  [mac_os_us] = "US",
  [mac_os_ru] = "RU",
}

M.layout_pretty_map = {
  ["US"] = "ENG",
  ["RU"] = "RUS",
}

function M.mac_os_current_layout()
  local cmd_out = vim.fn.system(
    [[defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | grep -w "KeyboardLayout Name" | awk '{print $4}']]
  )

  return M.mac_os_layout_map[cmd_out]
end

function M.lualine_keyboard_layout()
  local current_layout

  local function update_layout_infinitely()
    current_layout = M.mac_os_current_layout()
    vim.defer_fn(update_layout_infinitely, 300)
  end

  update_layout_infinitely()

  return function()
    return M.layout_pretty_map[current_layout]
  end
end

return M
