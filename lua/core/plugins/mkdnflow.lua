return {
	'jakewvincent/mkdnflow.nvim',
	config = function()
		require('mkdnflow').setup({
			to_do = {
				statuses = {
					{
						name = 'not_started',
						marker = ' ',
					},
					{
						name = 'in_progress',
						marker = '-',
					},
					{
						name = 'complete',
						marker = { 'X', 'x' },
					},
				},
				status_propagation = { up = true, down = true },
			},
		})
	end
}
