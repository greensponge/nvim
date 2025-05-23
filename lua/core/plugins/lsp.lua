return {
	-- LSP Configuration & Plugins
	'neovim/nvim-lspconfig',

	dependencies = {
		'saghen/blink.cmp',
		-- Automatically install LSPs to stdpath for neovim
		{ 'williamboman/mason.nvim', config = true },
		'williamboman/mason-lspconfig.nvim',

		-- Useful status updates for LSP
		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
		{ 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },

		-- Additional lua configuration, makes nvim stuff amazing!
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},
	-- [[ Configure LSP ]]
	--  This function gets run when an LSP connects to a particular buffer.
	config = function()
		local on_attach = function(_, bufnr)
			-- NOTE: Remember that lua is a real programming language, and as such it is possible
			-- to define small helper and utility functions so you don't have to repeat yourself
			-- many times.
			--
			-- In this case, we create a function that lets us more easily define mappings specific
			-- for LSP related items. It sets the mode, buffer and description for us each time.
			local nmap = function(keys, func, desc)
				if desc then
					desc = 'LSP: ' .. desc
				end

				vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
			end

			nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
			nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
			nmap('<leader>gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
			nmap('grr', vim.lsp.buf.references, 'Adds references under cursor directly to quicklist')
			nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
			nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
			nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
			nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
			nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols,
				'[W]orkspace [S]ymbols')

			-- See `:help K` for why this keymap
			nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
			nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

			-- Lesser used LSP functionality
			nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
			nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
			nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
			nmap('<leader>wl', function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, '[W]orkspace [L]ist Folders')

			-- Create a command `:Format` local to the LSP buffer
			vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
				vim.lsp.buf.format()
			end, { desc = 'Format current buffer with LSP' })
		end

		-- Enable the following language servers
		--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
		--
		--  Add any additional override configuration in the following tables. They will be passed to
		--  the `settings` field of the server config. You must look up that documentation yourself.
		--
		--  If you want to override the default filetypes that your language server will attach to you can
		--  define the property 'filetypes' to the map in question.
		local servers = {
			-- clangd = {},
			-- gopls = {},
			-- pyright = {},
			-- rust_analyzer = {},
			html = { filetypes = { 'html', 'twig', 'hbs' } },

			lua_ls = {
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			},
		}

		-- Ensure the servers above are installed
		local mason_lspconfig = require 'mason-lspconfig'

		mason_lspconfig.setup {
			ensure_installed = vim.tbl_keys(servers),
		}

		local capabilities = require('blink.cmp').get_lsp_capabilities()

		-- Configure default settings for all servers
		vim.lsp.config('*', {
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- Configure specific servers
		for server_name, config in pairs(servers) do
			vim.lsp.config(server_name, {
				settings = config,
				filetypes = config.filetypes,
			})
		end

		-- Switch for controlling whether you want autoformatting.
		--  Use :KickstartFormatToggle to toggle autoformatting on or off
		local format_is_enabled = true
		vim.api.nvim_create_user_command('KickstartFormatToggle', function()
			format_is_enabled = not format_is_enabled
			print('Setting autoformatting to: ' .. tostring(format_is_enabled))
		end, {})

		-- Create an augroup that is used for managing our formatting autocmds.
		--      We need one augroup per client to make sure that multiple clients
		--      can attach to the same buffer without interfering with each other.
		local _augroups = {}
		local get_augroup = function(client)
			if not _augroups[client.id] then
				local group_name = 'kickstart-lsp-format-' .. client.name
				local id = vim.api.nvim_create_augroup(group_name, { clear = true })
				_augroups[client.id] = id
			end

			return _augroups[client.id]
		end

		-- Whenever an LSP attaches to a buffer, we will run this function.
		--
		-- See `:help LspAttach` for more information about this autocmd event.
		vim.api.nvim_create_autocmd('LspAttach', {
			group = vim.api.nvim_create_augroup('kickstart-lsp-attach-format', { clear = true }),
			-- This is where we attach the autoformatting for reasonable clients
			callback = function(args)
				local client_id = args.data.client_id
				local client = vim.lsp.get_client_by_id(client_id)
				local bufnr = args.buf

				-- Only attach to clients that support document formatting
				if not client.server_capabilities.documentFormattingProvider then
					return
				end

				-- Tsserver usually works poorly. Sorry you work with bad languages
				-- You can remove this line if you know what you're doing :)
				--if client.name == 'tsserver' then
				--	return
				--end

				-- Create an autocmd that will run *before* we save the buffer.
				--  Run the formatting command for the LSP that has just attached.
				vim.api.nvim_create_autocmd('BufWritePre', {
					group = get_augroup(client),
					buffer = bufnr,
					callback = function()
						if not format_is_enabled then
							return
						end

						vim.lsp.buf.format {
							async = false,
							filter = function(c)
								return c.id == client.id
							end,
						}
					end,
				})
			end,
		})
	end
}
