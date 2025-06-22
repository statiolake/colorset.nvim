-- Pure Neovim implementation without rc.lib dependencies

require("colorset.types")
local highlights = require("colorset.highlights")

---@type table<string, ColorsetConfig>
local colorsets = {}
---@type ColorsetConfig?
local active_colorset = nil

---Set editor colorscheme
---@param scheme string
local function set_colorscheme(scheme)
	vim.cmd.colorscheme({ scheme })
	vim.api.nvim_exec_autocmds("ColorScheme", { pattern = scheme })
end

local hooks = highlights.get_default_hooks()

local function run_editor_colorscheme_hooks()
	for _, hook in ipairs(hooks) do
		hook()
	end
end

local M = {}

---List registered colorsets
function M.list_colorsets()
	local names = {}
	for name, _ in pairs(colorsets) do
		table.insert(names, name)
	end
	print(table.concat(names, " "))
end

---Setup colorset library
---@param config SetupConfig|string? Configuration table or colorset name for backward compatibility
function M.setup(config)
	config = config or {}

	-- Backward compatibility: if config is a string, treat it as default colorset
	if type(config) == "string" then
		config = { default = config }
	end

	-- Register colorsets from config
	if config.colorsets then
		for name, colorset_def in pairs(config.colorsets) do
			M.register(name, colorset_def)
		end
	end

	-- 起動したままカラーセットを切り替えるために :Colorset コマンドを追加する
	vim.api.nvim_create_user_command("Colorset", function(opts)
		if #opts.args > 0 then
			M.apply(opts.args)
		else
			M.list_colorsets()
		end
	end, {
		nargs = "?",
		complete = function()
			local names = {}
			for name, _ in pairs(colorsets) do
				table.insert(names, name)
			end
			return names
		end,
	})

	-- Add telescope command if telescope is available
	local has_telescope = pcall(require, "telescope")
	if has_telescope then
		vim.api.nvim_create_user_command("TelescopeColorset", function()
			require("telescope").extensions.colorset.colorsets()
		end, {
			desc = "Select colorset with Telescope",
		})
	end

	-- 起動時に初期カラーセットを登録する
	local default_colorset = config.default
	if default_colorset then
		vim.api.nvim_create_autocmd("UIEnter", {
			callback = function()
				M.apply(default_colorset)
			end,
			once = true,
		})
	end
end

---Register new colorset
---@param name string name of colorset
---@param colorset ColorsetConfig colorset specification
function M.register(name, colorset)
	if colorsets[name] ~= nil and not colorset.override then
		vim.notify(string.format('colorset "%s" is already registered; override', name), vim.log.levels.WARN)
	end
	colorsets[name] = colorset
end

---Register editor colorscheme hook
---@param hook fun()
function M.register_editor_colorscheme_hook(hook)
	table.insert(hooks, hook)
end

---Get all colorset specifications
---@return table<string, ColorsetConfig>
function M.get_all()
	return vim.deepcopy(colorsets)
end

---Get specific (or active if name is nil) colorset specifications
---@param name? string
---@return ColorsetConfig?
function M.get(name)
	return name and vim.deepcopy(colorsets[name]) or vim.deepcopy(active_colorset)
end

---Apply specified colorset
---@param name string
function M.apply(name)
	active_colorset = colorsets[name]
	if active_colorset == nil then
		vim.notify(string.format("unknown colorset: %s", name), vim.log.levels.ERROR)
		return
	end

	local background = active_colorset.background
	if background then
		vim.opt.background = background
	end

	local editor = active_colorset.editor
	if editor then
		set_colorscheme(editor)
		run_editor_colorscheme_hooks()
	end

	local hook = active_colorset.hook or function() end
	hook()
end

return M
