return {
	"karb94/neoscroll.nvim",
	config = function()
		require('neoscroll').setup { mappings = { "<C-u>", "<C-d>" } }

		local t = {}
		-- Syntax: t[keys] = {function, {function arguments}}
		t['<C-u>'] = { 'scroll', { '-vim.wo.scroll', 'true', '150' } }
		t['<C-d>'] = { 'scroll', { 'vim.wo.scroll', 'true', '150' } }

		require('neoscroll.config').set_mappings(t)
	end
}
