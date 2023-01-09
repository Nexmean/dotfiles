return function()
  local cybu = require "cybu"
  cybu.setup {
    display_time = 1500,
    position = {
      relative_to = "win",
      anchor = "topright",
      vertical_offset = 0,
      horizontal_offset = 1,
      max_win_height = 15,
    },
    style = {
      border = "single",
      highlights = {
        background = "CybuBackground",
      },
    },
    behavior = {
      mode = {
        last_used = {
          switch = "immediate",
          view = "paging",
        },
      },
    },
  }
end
