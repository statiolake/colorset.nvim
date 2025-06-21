---@class ColorsetConfig
---@field background? 'light'|'dark' Background setting for the colorset
---@field editor? string Colorscheme name for the editor
---@field hook? fun() Function executed after this colorset is applied
---@field override? boolean Whether to override existing colorset

---@class SetupConfig
---@field colorsets? table<string, ColorsetConfig> Table of colorset definitions
---@field default? string Default colorset name to apply on startup

return {}