return {
	'jakewvincent/mkdnflow.nvim',
	config = function()
		require('mkdnflow').setup({
			-- Config goes here; leave blank for defaults
			to_do = {
				symbols = { ' ', '-', 'x' },
				update_parents = true,
				not_started = ' ',
				in_progress = '-',
				complete = 'x'
			},
		})
	end
}
