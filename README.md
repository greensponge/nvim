# How to use this config
Clone the repository to `~/.config` so the final folder structure looks like this `~/.config/nvim`. From there you may do anything you wish, like editing the name `greensponge` to `your-preferred-name` instead.

# How to add plugins
This project uses [Packer](https://github.com/wbthomason/packer.nvim). 
To add a new plugin go to `nvim/lua/greensponge/packer.lua`:
1. Add plugin using the Packer syntax.
2. Run `:so` to source the file
3. Run `:PackerSync` to sync packages. This will add/remove/update based on the contents in the `packer.lua` file.

# LSP servers, DAP servers, linters, and formatters
You can run `:Mason` to open up a window to check and install any LSP, DAP, linter, or formatter you wish to use. You can also find updates and install those from this interface as well.

# Floating terminal
I like to have quick access to a terminal for a lot of reasons. To use the one I have in my config press `t` to toggle the terminal. This terminal will float up inside your terminal. If no floating terminal currently exists a new one will be created, otherwise it will bring up the existing floating terminal. Press `<ESC>` to exit the terminal.
