# colorset.nvim

A Neovim plugin for managing and switching between colorscheme configurations with support for telescope.nvim integration and live preview.

## Features

- 🎨 **Colorset Management**: Define and organize multiple colorscheme configurations
- 🔭 **Telescope Integration**: Browse and preview colorsets with telescope.nvim
- 👀 **Live Preview**: See colorscheme changes in real-time while browsing
- ⚡ **Pure Neovim**: No external dependencies, uses only native Neovim APIs
- 🔧 **Customizable**: Support for custom hooks and highlight configurations
- 📝 **Type Safe**: Full LuaLS type annotations for better development experience

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'your-username/colorset.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim', -- Optional: for telescope integration
  },
  config = function()
    require('colorset').setup({
      -- Your configuration here
    })
  end
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'your-username/colorset.nvim',
  requires = {
    'nvim-telescope/telescope.nvim', -- Optional
  },
  config = function()
    require('colorset').setup({
      -- Your configuration here
    })
  end
}
```

## Usage

### Basic Setup

```lua
require('colorset').setup {
  colorsets = {
    gruvbox_dark = {
      background = 'dark',
      editor = 'gruvbox',
    },
    solarized_light = {
      background = 'light',
      editor = 'solarized',
    },
    nord = {
      background = 'dark',
      editor = 'nord',
      hook = function()
        -- Custom configuration for nord theme
        vim.g.nord_contrast = true
      end
    },
  },
  default = 'gruvbox_dark', -- Applied on startup
}
```

### Advanced Configuration

```lua
require('colorset').setup {
  colorsets = {
    my_custom_theme = {
      background = 'dark',
      editor = 'gruvbox',
      hook = function()
        -- Custom highlights and settings
        vim.cmd([[
          highlight Comment gui=italic
          highlight Function gui=bold
        ]])
        
        -- Plugin-specific settings
        vim.g.airline_theme = 'gruvbox'
      end,
      override = true, -- Allow overriding existing colorsets
    },
  },
  default = 'my_custom_theme',
}
```

## Commands

### Built-in Commands

- `:Colorset` - List all available colorsets
- `:Colorset <name>` - Apply a specific colorset

### Telescope Integration

If telescope.nvim is installed, additional commands are available:

- `:TelescopeColorset` - Open telescope picker with live preview
- `:Telescope colorset colorsets` - Alternative telescope command

#### Telescope Usage

1. Run `:TelescopeColorset`
2. Use `↑/↓` or `j/k` to navigate between colorsets
3. See live preview as you move through the list
4. Press `Enter` to apply the selected colorset
5. Press `Esc` or `q` to cancel and restore the original colorset

## API Reference

### Setup Configuration

```lua
---@class SetupConfig
---@field colorsets? table<string, ColorsetConfig> Table of colorset definitions
---@field default? string Default colorset name to apply on startup
```

### Colorset Configuration

```lua
---@class ColorsetConfig
---@field background? 'light'|'dark' Background setting for the colorset
---@field editor? string Colorscheme name for the editor
---@field hook? fun() Function executed after this colorset is applied
---@field override? boolean Whether to override existing colorset
```

### Functions

#### `require('colorset').setup(config)`

Initialize the plugin with configuration.

#### `require('colorset').register(name, colorset)`

Register a new colorset programmatically.

```lua
require('colorset').register('my_theme', {
  background = 'dark',
  editor = 'gruvbox',
  hook = function()
    vim.g.gruvbox_contrast_dark = 'hard'
  end
})
```

#### `require('colorset').apply(name)`

Apply a specific colorset by name.

```lua
require('colorset').apply('my_theme')
```

#### `require('colorset').get_all()`

Get all registered colorsets.

#### `require('colorset').get(name?)`

Get a specific colorset configuration, or the currently active one if no name is provided.

#### `require('colorset').register_editor_colorscheme_hook(hook)`

Register a global hook that runs after any colorscheme change.

```lua
require('colorset').register_editor_colorscheme_hook(function()
  -- This runs after every colorscheme change
  vim.cmd('highlight! link CustomGroup SpecialKey')
end)
```

## Examples

### Theme Collections

```lua
-- Organize themes by time of day
require('colorset').setup {
  colorsets = {
    morning = {
      background = 'light',
      editor = 'solarized',
      hook = function()
        vim.opt.guifont = 'JetBrains Mono:h12'
      end
    },
    evening = {
      background = 'dark',
      editor = 'gruvbox',
      hook = function()
        vim.opt.guifont = 'JetBrains Mono:h14'
      end
    },
    night = {
      background = 'dark',
      editor = 'nord',
      hook = function()
        vim.opt.guifont = 'JetBrains Mono:h16'
      end
    },
  },
  default = 'morning',
}
```

### Language-Specific Themes

```lua
-- Auto-switch themes based on filetype
require('colorset').setup {
  colorsets = {
    coding = {
      background = 'dark',
      editor = 'gruvbox',
    },
    writing = {
      background = 'light',
      editor = 'solarized',
    },
  },
  default = 'coding',
}

-- Auto-switch based on filetype
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'text', 'tex' },
  callback = function()
    require('colorset').apply('writing')
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'lua', 'python', 'javascript', 'rust' },
  callback = function()
    require('colorset').apply('coding')
  end,
})
```

## Backward Compatibility

The plugin maintains backward compatibility with the old API:

```lua
-- Old way (still supported)
require('colorset').setup('my_default_theme')

-- New way (recommended)
require('colorset').setup {
  default = 'my_default_theme',
  colorsets = {
    -- colorset definitions
  }
}
```

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## License

MIT License