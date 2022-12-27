local path = require("project_nvim.utils.path")
local uv = vim.loop
local is_windows = vim.fn.has('win32') or vim.fn.has('wsl')
local history = require("project_nvim.utils.history")

local M = {}

local function open_history(mode)
  path.create_scaffolding()
  return uv.fs_open(path.historyfile, mode, 438)
end

local function normalise_path(path_to_normalise)
  local normalised_path = path_to_normalise:gsub("\\", "/"):gsub("//", "/")

  if is_windows then
     normalised_path = normalised_path:sub(1,1):lower()..normalised_path:sub(2)
  end

  return normalised_path
end

local function dir_exists(dir)
  local stat = uv.fs_stat(dir)
  if stat ~= nil and stat.type == "directory" then
    return true
  end
  return false
end

local function delete_duplicates(tbl)
  local cache_dict = {}
  for _, v in ipairs(tbl) do
    local normalised_path = normalise_path(v)
    if cache_dict[normalised_path] == nil then
      cache_dict[normalised_path] = 1
    else
      cache_dict[normalised_path] = cache_dict[normalised_path] + 1
    end
  end

  local res = {}
  for _, v in ipairs(tbl) do
    local normalised_path = normalise_path(v)
    if cache_dict[normalised_path] == 1 then
      table.insert(res, normalised_path)
    else
      cache_dict[normalised_path] = cache_dict[normalised_path] - 1
    end
  end
  return res
end

local function deserialize_history(history_data)
  -- split data to table
  local projects = {}
  for s in history_data:gmatch("[^\r\n]+") do
    if not path.is_excluded(s) and dir_exists(s) then
      table.insert(projects, s)
    end
  end

  projects = delete_duplicates(projects)

  history.recent_projects = projects
end

function M.read_projects_from_history()
  local fd = open_history "r"
  local stat = uv.fs_fstat(fd)
  local data = uv.fs_read(fd, stat.size, -1)
  uv.fs_close(fd)
  deserialize_history(data)
end

return M
