-- :fennel:1659476272
local function concat(...)
  local result = {}
  for _, list in ipairs(...) do
    for _0, e in ipairs(list) do
      table.insert(result, e)
    end
  end
  return result
end
local function load_base_config(name)
  local present_3f, config = pcall(require, ("plugins." .. name))
  if not present_3f then
    error(("load-base-configs: \"" .. name .. "\" config isn't present"))
  else
  end
  if vim.tbl_islist(config) then
    local tbl_15_auto = {}
    local i_16_auto = #tbl_15_auto
    for _, _2_ in ipairs(config) do
      local _each_3_ = _2_
      local name0 = _each_3_[1]
      local config_23 = _each_3_[2]
      local val_17_auto = vim.tbl_extend("keep", {as = name0}, config_23)
      if (nil ~= val_17_auto) then
        i_16_auto = (i_16_auto + 1)
        do end (tbl_15_auto)[i_16_auto] = val_17_auto
      else
      end
    end
    return tbl_15_auto
  else
    return {vim.tbl_extend("keep", {as = name}, config)}
  end
end
local function load_config(raw_plugin)
  local function _8_()
    local _7_ = raw_plugin
    if ((_G.type(_7_) == "table") and (nil ~= (_7_)[1]) and (nil ~= (_7_)[2])) then
      local name = (_7_)[1]
      local overrides = (_7_)[2]
      return {name, overrides}
    elseif ((_G.type(_7_) == "table") and (nil ~= (_7_)[1])) then
      local name = (_7_)[1]
      return {name, {}}
    elseif (nil ~= _7_) then
      local name = _7_
      return {name, {}}
    else
      return nil
    end
  end
  local _var_6_ = _8_()
  local name = _var_6_[1]
  local overrides_raw = _var_6_[2]
  local base_config = load_base_config(name)
  local overrides
  if vim.tbl_islist(overrides_raw) then
    overrides = overrides_raw
  else
    local plugin_names
    do
      local tbl_15_auto = {}
      local i_16_auto = #tbl_15_auto
      for _, p in ipairs(base_config) do
        local val_17_auto = p.as
        if (nil ~= val_17_auto) then
          i_16_auto = (i_16_auto + 1)
          do end (tbl_15_auto)[i_16_auto] = val_17_auto
        else
        end
      end
      plugin_names = tbl_15_auto
    end
    local tbl_15_auto = {}
    local i_16_auto = #tbl_15_auto
    for _, pn in ipairs(plugin_names) do
      local val_17_auto = {pn, overrides_raw}
      if (nil ~= val_17_auto) then
        i_16_auto = (i_16_auto + 1)
        do end (tbl_15_auto)[i_16_auto] = val_17_auto
      else
      end
    end
    overrides = tbl_15_auto
  end
  local overrides_table
  do
    local tbl_12_auto = {}
    for _, _13_ in ipairs(overrides) do
      local _each_14_ = _13_
      local name0 = _each_14_[1]
      local override = _each_14_[2]
      local _15_, _16_ = name0, override
      if ((nil ~= _15_) and (nil ~= _16_)) then
        local k_13_auto = _15_
        local v_14_auto = _16_
        tbl_12_auto[k_13_auto] = v_14_auto
      else
      end
    end
    overrides_table = tbl_12_auto
  end
  local tbl_15_auto = {}
  local i_16_auto = #tbl_15_auto
  for _, plugin in ipairs(base_config) do
    local val_17_auto
    do
      local new_plugin = vim.tbl_deep_extend("keep", (overrides_table[plugin.as] or {}), plugin)
      val_17_auto = new_plugin
    end
    if (nil ~= val_17_auto) then
      i_16_auto = (i_16_auto + 1)
      do end (tbl_15_auto)[i_16_auto] = val_17_auto
    else
    end
  end
  return tbl_15_auto
end
local function load_configs(raw_plugins)
  local all_plugins
  local function _19_()
    local tbl_15_auto = {}
    local i_16_auto = #tbl_15_auto
    for _, raw_plugin in ipairs(raw_plugins) do
      local val_17_auto = load_config(raw_plugin)
      if (nil ~= val_17_auto) then
        i_16_auto = (i_16_auto + 1)
        do end (tbl_15_auto)[i_16_auto] = val_17_auto
      else
      end
    end
    return tbl_15_auto
  end
  all_plugins = concat(_19_())
  for _, plugin in ipairs(all_plugins) do
    plugin[1] = plugin.from
    plugin.from = nil
  end
  return all_plugins
end
return {["load-configs"] = load_configs}