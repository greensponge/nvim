local map = vim.keymap.set

-- Fuzzy Finder (files, lsp, etc)
return {
	'nvim-telescope/telescope.nvim',
	branch = '0.1.x',
	dependencies = {
		'nvim-lua/plenary.nvim',
		-- Fuzzy Finder Algorithm which requires local dependencies to be built.
		-- Only load if `make` is available. Make sure you have the system
		-- requirements installed.
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			-- NOTE: If you are having trouble with this installation,
			--       refer to the README for telescope-fzf-native for more instructions.
			build = 'make',
			cond = function()
				return vim.fn.executable 'make' == 1
			end,
		},
	},
	config = function()
		local telescope = require('telescope')
		-- [[ Configure Telescope ]]
		-- See `:help telescope` and `:help telescope.setup()`
		telescope.setup {
			defaults = {
				mappings = {
					i = {
						['<C-u>'] = false,
						['<C-d>'] = false,
					},
				},
			},
		}

		-- Enable telescope fzf native, if installed
		pcall(telescope.load_extension, 'fzf')
		telescope.load_extension("projects")

		-- See `:help telescope.builtin`
		map('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
		map('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
		map('n', '<leader>/', function()
			-- You can pass additional configuration to telescope to change theme, layout, etc.
			require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
				winblend = 10,
				previewer = false,
			})
		end, { desc = '[/] Fuzzily search in current buffer' })

		map('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
		map('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
		map('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
		map('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
		map('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
		map('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
		map('n', '<leader>sp', require('telescope').extensions.projects.projects,
			{ desc = '[S]earch [P]rojects' })
	end
}
