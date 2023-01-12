return function()
  local alpha = require("alpha")
  local banners = require("user.plugins.alpha.banners")

  local api = vim.api
  local au = Config.common.au
  local hl = Config.common.hl
  local utils = Config.common.utils

  local elements = {
    header = {},
    buttons = {},
    footer = {},
  }

  local function get_banner()
    local height = api.nvim_win_get_height(0)
    local list = { "nvim" }
    local bg = vim.o.background
    local result

    for _, name in ipairs(list) do
      local banner = banners[name .. "_" .. bg] or banners[name]
      result = vim.split(banner, "\n", {})
      if height >= #result + 20 then
        return result
      end
    end

    return {}
  end

  local function on_press(keybind)
    return function()
      local key = vim.api.nvim_replace_termcodes(keybind .. "<Ignore>", true, false, true)
      vim.api.nvim_feedkeys(key, "t", false)
    end
  end

  local keybind_opts = { noremap = false, silent = true, nowait = true }

  local function cmd(cmdv)
    return "<cmd> " .. cmdv .. " <CR>"
  end

  local function session_button(i, session)
    local i_string = tostring(i)
    local sc = "[" .. i_string .. "] "

    local val = utils.str_right_pad(session.dir_path, 50)
      .. utils.str_right_pad("on  " .. session.branch, 30)

    local req_utils = [[local u = require("persisted.utils");]]
    local req_conf = [[local c = require("persisted.config");]]
    local load_session = string.format(
      [[u.load_session("%s", c.before_source, c.after_source, c.options.silent)]],
      session.file_path
    )

    local cmdtext = cmd("lua " .. req_utils .. req_conf .. load_session)

    local opts = {
      position = "center",
      shortcut = sc,
      cursor = 1,
      align_shortcut = "left",
      hl = {
        {"@character", 1 - #sc, 50 - #sc},
        {"@character.special", 52, 80}
      },
      hl_shortcut = {
        {"@punctuation.bracket", 0, 1},
        {"@number", 1, 2},
        {"@punctuation.bracket", 2, 3}
      },
      width = 80,
      keymap = {"n", i_string, cmdtext, keybind_opts},
    }

    return {
      type = "button",
      val = val,
      on_press = on_press(i_string),
      opts = opts,
    }
  end

  local recent_sessions_button = {
    type = "button",
    val = utils.str_right_pad("Recent sessions", 78),
    on_press = on_press "s",
    opts = {
      position = "center",
      shortcut = "[s] ",
      cursor = 1,
      align_shortcut = "left",
      hl = {
        {"@label", -3, 76},
      },
      hl_shortcut = {
        {"@punctuation.bracket", 0, 1},
        {"@number", 1, 2},
        {"@punctuation.bracket", 2, 3}
      },
      width = 80,
      keymap = { "n", "s", cmd "Telescope persisted", keybind_opts },
    },
  }

  local function project_button(i, project)
    local i_string = tostring(i)
    local sc = "[" .. i_string .. "] "

    local cmdv = cmd(string.format(
      [[lua require("project_nvim.project").set_pwd("%s", "alpha")]],
      project
    ))

    local opts = {
      position = "center",
      shortcut = sc,
      cursor = 1,
      align_shortcut = "left",
      hl = {
        {"@character", 1 - #sc, 80 - #sc}
      },
      hl_shortcut = {
        {"@punctuation.bracket", 0, 1},
        {"@number", 1, 2},
        {"@punctuation.bracket", 2, 3}
      },
      width = 80 - #sc,
      keymap = {"n", i_string, cmdv, keybind_opts}
    }

    local path_separator
    if jit.os == "Windows" then
      path_separator = "\\"
    else
      path_separator = "/"
    end

    return {
      type = "button",
      val = utils.str_right_pad(project:gsub(vim.fn.getenv("HOME") .. path_separator, ""), 80 - (#sc / 2)),
      on_press = on_press(i_string),
      opts = opts
    }
  end

  local recent_projects_button = {
    type = "button",
    val = utils.str_right_pad("Recent projects", 78),
    on_press = on_press "p",
    opts = {
      align_shortcut = "left",
      cursor = 1,
      position = "center",
      shortcut = "[p] ",
      hl = {
        {"@label", -3, 76}
      },
      hl_shortcut = {
        {"@punctuation.bracket", 0, 1},
        {"@number", 1, 2},
        {"@punctuation.bracket", 2, 3}
      },
      width = 80,
      keymap = { "n", "p", cmd "Telescope projects", keybind_opts },
    }
  }

  local function setup_buffer()
    vim.opt_local.list = false
    vim.opt_local.winhl = table.concat({
      "Normal:DashboardNormal",
      "EndOfBuffer:DashboardEndOfBuffer",
    }, ",")
  end

  local function setup_highlights()
    hl.hi_link("DashboardNormal", "Normal", { default = true })
    hl.hi("DashboardEndOfBuffer", { fg = hl.get_bg("Normal"), bg = hl.get_bg("Normal"), default = true })
    hl.hi_link("DashboardHeader", "Type", { default = true })
    hl.hi_link("DashboardCenter", "Keyword", { default = true })
    -- hl.hi_link("DashboardShortCut", "String", { default = true })
    hl.hi("DashboardShortCut", { fg = hl.get_fg("String"), gui = "bold,reverse", default = true })
    hl.hi_link("DashboardFooter", "Number", { default = true })
  end

  local function init_elements()
    local version_lines = vim.split(vim.api.nvim_exec("version", true), "\n", {})

    elements.header = {
      type = "text",
      val = get_banner(),
      opts = {
        position = "center",
        hl = "DashboardHeader",
      },
    }

    elements.footer = {
      type = "text",
      val = { " " ..  version_lines[2] },
      opts = {
        position = "center",
        hl = "DashboardFooter",
      },
    }

    local persisted = require("persisted")
    local sessions = persisted.list()
    table.sort(sessions, function (a, b)
      return vim.loop.fs_stat(a.file_path).mtime.sec > vim.loop.fs_stat(b.file_path).mtime.sec
    end)
    sessions = utils.vec_slice(sessions, 1, 5)
    elements.sessions = {recent_sessions_button}
    for i, session in ipairs(sessions) do
      table.insert(elements.sessions, session_button(i, session))
    end

    local project_nvim = require("project_nvim.utils.history")
    local projects = utils.vec_slice(project_nvim.get_recent_projects(), 1, 5)
    elements.projects = {recent_projects_button}
    for i, project in ipairs(projects) do
      table.insert(elements.projects, project_button((#sessions + i) % 10, project))
    end
  end

  au.declare_group("alpha_config", {}, {
    {
      "User",
      pattern = "AlphaReady",
      callback = function()
        setup_buffer()
      end,
    },
    {
      "ColorScheme",
      pattern = "*",
      callback = function(_)
        setup_highlights()
      end,
    }
  })

  local project_sync = require("user.plugins.project.sync")
  project_sync.read_projects_from_history()

  init_elements()
  setup_highlights()

  alpha.setup({
    opts = {
      margin = 5,
    },
    layout = {
      { type = "padding", val = 1, },
      elements.header,
      { type = "padding", val = 2, },
      {
        type = "group",
        opts = {
          spacing = 1,
        },
        val = elements.sessions,
      },
      { type = "padding", val = 1, },
      {
        type = "group",
        opts = {
          spacing = 1,
        },
        val = elements.projects,
      },
      elements.footer,
    },
  })
end
