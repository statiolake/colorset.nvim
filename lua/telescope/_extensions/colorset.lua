local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
	error("telescope.nvim is required for this extension")
end

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local config = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local colorset = require("colorset")

local M = {}

-- Store original colorset for preview restoration
local original_colorset = nil

-- Preview function that applies colorset temporarily
local function preview_colorset(name)
	if name and name ~= "" then
		colorset.apply(name)
	end
end

-- Restore original colorset
local function restore_original_colorset()
	if original_colorset then
		colorset.apply(original_colorset)
	end
end

-- Get current active colorset name
local function get_current_colorset()
	local current = colorset.get()
	if not current then
		return nil
	end

	-- Find the name of the current colorset by comparing with all registered colorsets
	local all_colorsets = colorset.get_all()
	for name, config_data in pairs(all_colorsets) do
		if vim.deep_equal(current, config_data) then
			return name
		end
	end
	return nil
end

function M.colorsets(opts)
	opts = opts or {}

	-- Store the current colorset for restoration
	original_colorset = get_current_colorset()

	local all_colorsets = colorset.get_all()
	local colorset_names = {}

	for name, _ in pairs(all_colorsets) do
		table.insert(colorset_names, name)
	end

	table.sort(colorset_names)

	pickers
		.new(opts, {
			prompt_title = "Colorsets",
			finder = finders.new_table({
				results = colorset_names,
				entry_maker = function(entry)
					return {
						value = entry,
						display = entry,
						ordinal = entry,
					}
				end,
			}),
			sorter = config.generic_sorter(opts),
			previewer = false,
			attach_mappings = function(prompt_bufnr, map)
				-- Live preview on selection change
				local function on_selection_change()
					local picker = action_state.get_current_picker(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					if selection then
						preview_colorset(selection.value)
					end
				end

				-- Override movement actions to trigger preview
				map("i", "<Down>", function()
					actions.move_selection_next(prompt_bufnr)
					on_selection_change()
				end)

				map("i", "<Up>", function()
					actions.move_selection_previous(prompt_bufnr)
					on_selection_change()
				end)

				map("i", "<C-n>", function()
					actions.move_selection_next(prompt_bufnr)
					on_selection_change()
				end)

				map("i", "<C-p>", function()
					actions.move_selection_previous(prompt_bufnr)
					on_selection_change()
				end)

				map("n", "j", function()
					actions.move_selection_next(prompt_bufnr)
					on_selection_change()
				end)

				map("n", "k", function()
					actions.move_selection_previous(prompt_bufnr)
					on_selection_change()
				end)

				map("n", "<Down>", function()
					actions.move_selection_next(prompt_bufnr)
					on_selection_change()
				end)

				map("n", "<Up>", function()
					actions.move_selection_previous(prompt_bufnr)
					on_selection_change()
				end)

				-- Apply colorset on selection
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)

					if selection then
						colorset.apply(selection.value)
						original_colorset = selection.value -- Update the stored original
					else
						restore_original_colorset()
					end
				end)

				-- Restore original colorset on escape/cancel
				map("i", "<C-c>", function()
					restore_original_colorset()
					actions.close(prompt_bufnr)
				end)

				map("n", "<Esc>", function()
					restore_original_colorset()
					actions.close(prompt_bufnr)
				end)

				map("n", "q", function()
					restore_original_colorset()
					actions.close(prompt_bufnr)
				end)

				-- Initial preview for first item
				vim.defer_fn(function()
					if vim.api.nvim_buf_is_valid(prompt_bufnr) then
						on_selection_change()
					end
				end, 50)

				return true
			end,
		})
		:find()
end

return {
	exports = {
		colorsets = M.colorsets,
	},
}
