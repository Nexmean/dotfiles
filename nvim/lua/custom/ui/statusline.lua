local modules = require "ui.statusline.modules"

local M = {}

function M.run()
   return table.concat {
      modules.mode(),
      modules.fileInfo(),
      modules.git(),

      "%=",
      modules.LSP_progress(),
      "%=",

      modules.LSP_Diagnostics(),
      modules.LSP_status() or "",
      modules.cwd(),
      modules.cursor_position(),
   }
end

return M
