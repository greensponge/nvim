--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where lazy will load every plugin that exists in core/plugins. 
-- -- If you want to add a new plugin, simply create a lua file in core/plugins and return the plugin name/settings, 
-- -- check any file in plugins for examples. 
-- -- Short example: 
-- return { 
-- 'someplugin', 
-- 'config = function () 
-- -- specific_plugin_settings 
-- end 
-- }
require('lazy').setup("core.plugins", {})
