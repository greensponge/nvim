# kickstart.nvim
This configuration is started from the kickstart template located here: https://github.com/nvim-lua/kickstart.nvim

# How to use
Clone down this repository to `~/.config/nvim`, pay attention that this is the final path, and not `~/.config/nvim/nvim` or something else. It should then load all the required plugins and settings the next time you launch `neovim`.

For now I use the same bindings for at least `telescope` as `TJ` from `kickstart`. You can check out his [video tutorial](https://www.youtube.com/watch?v=stqUbv-5u2s) if you need help learning the shortcuts and how to teach yourself what is available.

# Structure
The main `init.lua` file only requires from the needed modules.

Under `lua/core` you will find this structure:
```
plugins/
lazy.lua
mappings.lua
```
The `plugins/` directory contains all plugins, each separated by a file. To add a plugin simply create a new file in this folder, returning the required plugin information.
The `lazy.lua` file contains the package manager, which will load each file under `plugins/`.
The `mappings.lua` contains "global" mappings, or rather mappings I don't know where to otherwise put, as they do not belong to a plugin.
