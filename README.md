# Neovim Configuration

A clean and modular Neovim configuration using `lazy.nvim` as the plugin manager.

## Features

- **Plugin Manager**: [lazy.nvim](https://github.com/folke/lazy.nvim) for fast and easy plugin management.
- **Theme**: [Catppuccin](https://github.com/catppuccin/nvim) (Frappe flavour) for a vibrant and eye-pleasing aesthetic.
- **Options**:
  - `mapleader` set to space.
  - 4-space indentation.
  - Relative line numbers enabled.

## Installation

1. Clone this repository into your Neovim configuration directory:
   ```bash
   git clone <repo-url> ~/.config/nvim
   ```
2. Start Neovim:
   ```bash
   nvim
   ```
   `lazy.nvim` will automatically bootstrap and install the configured plugins.

## Structure

- `init.lua`: Main entry point, loads the plugin configuration.
- `lua/config/lazy.lua`: Bootstraps `lazy.nvim` and contains core settings and plugin setups.
- `lua/plugins/`: Directory for additional plugin configurations.
