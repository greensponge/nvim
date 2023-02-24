-- This file can be loaded by calling `lua require('plugins')` from your init.vim  
-- Only required if you have packer configured as `opt` 
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
-- Packer can manage itself
use 'wbthomason/packer.nvim'

use {
	'nvim-telescope/telescope.nvim', tag = '0.1.0',
	requires = { {'nvim-lua/plenary.nvim'} }
}

use 'navarasu/onedark.nvim'
use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
use('theprimeagen/harpoon')
use('mbbill/undotree')
use('tpope/vim-fugitive')

use {
    'VonHeikemen/lsp-zero.nvim',
    requires = {
        -- LSP Support
        {'neovim/nvim-lspconfig'},
        {'williamboman/mason.nvim'},
        {'williamboman/mason-lspconfig.nvim'},
        {'simrat39/rust-tools.nvim'},
        {'jose-elias-alvarez/null-ls.nvim'},
        {'MunifTanjim/prettier.nvim'},
        -- Autocompletion
        {'saadparwaiz1/cmp_luasnip'},
        {'hrsh7th/nvim-cmp'},
        {'hrsh7th/cmp-nvim-lsp'},
        {'hrsh7th/cmp-buffer'},
        {'hrsh7th/cmp-path'},
        {'hrsh7th/cmp-nvim-lua'},
        {'hrsh7th/cmp-nvim-lsp-signature-help'},
        {'hrsh7th/cmp-vsnip'},
        {'hrsh7th/vim-vsnip'},
        -- Snippets
        {'L3MON4D3/LuaSnip'},
    }
}

use 'Olical/conjure'
use 'tpope/vim-dispatch'
use 'clojure-vim/vim-jack-in'
use 'radenling/vim-dispatch-neovim'
use {'nvim-orgmode/orgmode', config = function()
    require('orgmode').setup{}
end}
use {'akinsho/org-bullets.nvim', config = function()
    require('org-bullets').setup()
end}
use 'tpope/vim-speeddating'
use 'puremourning/vimspector'
use 'voldikss/vim-floaterm'

use {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
        require("todo-comments").setup {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    end
}

end)
