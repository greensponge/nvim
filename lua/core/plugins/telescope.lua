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
		local builtin = require('telescope.builtin')

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

		-- See `:help telescope.builtin`
		map('n', '<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })
		map('n', '<leader><space>', builtin.buffers, { desc = '[ ] Find existing buffers' })
		map('n', '<leader>/', function()
			-- You can pass additional configuration to telescope to change theme, layout, etc.
			builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
				winblend = 10,
				previewer = false,
			})
		end, { desc = '[/] Fuzzily search in current buffer' })

		map('n', '<leader>gf', builtin.git_files, { desc = 'Search [G]it [F]iles' })
		map('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
		map('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
		map('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
		map('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
		map('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
		map('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]ecent' })
		map('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]ey Maps' })
		map('n', '<leader>sc', builtin.git_commits, { desc = '[S]earch Git [C]ommits' })

		-- neovim-project specific bind
		map('n', '<leader>pd', ':NeovimProjectDiscover<CR>', { desc = '[P]roject [D]iscover' })
		map('n', '<leader>ph', ':NeovimProjectHistory<CR>', { desc = '[P]roject [H]istory' })
		map('n', '<leader>plr', ':NeovimProjectLoadRecent<CR>', { desc = '[P]roject [L]oad [R]ecent' })
	end
}
