return {
	'echasnovski/mini.map',
	version = false,
	config = function()
		require('mini.map').setup()

		MiniMap.config.symbols.encode = MiniMap.gen_encode_symbols.dot('4x2');

		vim.keymap.set('n', '<Leader>mc', MiniMap.close)
		vim.keymap.set('n', '<Leader>mf', MiniMap.toggle_focus)
		vim.keymap.set('n', '<Leader>mo', MiniMap.open)
		vim.keymap.set('n', '<Leader>mr', MiniMap.refresh)
		vim.keymap.set('n', '<Leader>ms', MiniMap.toggle_side)
		vim.keymap.set('n', '<Leader>mt', MiniMap.toggle)
	end,
}
