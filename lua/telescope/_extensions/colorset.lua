local has_telescope, telescope = pcall(require, 'telescope')
if not has_telescope then
  error('telescope.nvim is required for this extension')
end

local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local config = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local colorset = require('colorset')

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
  
  pickers.new(opts, {
    prompt_title = 'Colorsets',
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
    attach_mappings = function(prompt_bufnr, map)
      -- Live preview on cursor movement
      local function on_cursor_moved()
        local selection = action_state.get_selected_entry()
        if selection then
          preview_colorset(selection.value)
        end
      end
      
      -- Set up cursor moved callback for live preview
      vim.api.nvim_create_autocmd('CursorMoved', {
        buffer = prompt_bufnr,
        callback = on_cursor_moved,
      })
      
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
      map('i', '<C-c>', function()
        restore_original_colorset()
        actions.close(prompt_bufnr)
      end)
      
      map('n', '<Esc>', function()
        restore_original_colorset() 
        actions.close(prompt_bufnr)
      end)
      
      map('n', 'q', function()
        restore_original_colorset()
        actions.close(prompt_bufnr)
      end)
      
      -- Initial preview
      vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(prompt_bufnr) then
          on_cursor_moved()
        end
      end, 50)
      
      return true
    end,
  }):find()
end

return telescope.register_extension({
  setup = function()
    -- Extension setup if needed
  end,
  exports = {
    colorsets = M.colorsets,
  },
})