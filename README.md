# colorset.nvim

Neovim colorscheme manager with telescope.nvim integration and live preview.

## Features

- Manage multiple colorscheme configurations
- Telescope integration with live preview
- Custom hooks for theme-specific settings
- Pure Neovim APIs, no external dependencies

## Installation

```lua
-- lazy.nvim
{
  'your-username/colorset.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim' }, -- optional
  config = function()
    require('colorset').setup({
      colorsets = {
        gruvbox_dark = {
          background = 'dark',
          editor = 'gruvbox',
        },
        solarized_light = {
          background = 'light',
          editor = 'solarized',
        },
      },
      default = 'gruvbox_dark',
    })
  end
}
```

## Usage

### Commands
- `:Colorset` - List colorsets
- `:Colorset <name>` - Apply colorset
- `:TelescopeColorset` - Browse with live preview (requires telescope.nvim)

### Configuration

```lua
require('colorset').setup {
  colorsets = {
    my_theme = {
      background = 'dark',
      editor = 'gruvbox',
      hook = function()
        -- Custom settings for this theme
        vim.g.gruvbox_contrast_dark = 'hard'
      end,
    },
  },
  default = 'my_theme',
}
```

### API

```lua
local colorset = require('colorset')

-- Register new colorset
colorset.register('theme_name', {
  background = 'dark',
  editor = 'nord',
})

-- Apply colorset
colorset.apply('theme_name')

-- Add global hook
colorset.register_editor_colorscheme_hook(function()
  -- Runs after every colorscheme change
end)
```

## License

MIT