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

use {
	'rose-pine/neovim',
	as = 'rose-pine',
	config = function()
		vim.cmd('colorscheme rose-pine')
	end
}

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
use 'jceb/vim-orgmode'
use 'tpope/vim-speeddating'
use 'puremourning/vimspector'
use 'voldikss/vim-floaterm'

end)
