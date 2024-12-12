return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		bigfile = { enabled = true },
		dashboard = { enabled = true },
		indent = { enabled = true },
		input = { enabled = true },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		zen = { enabled = true },
		scratch = { enabled = true }
	},
	keys = {
		{ "<leader>z", function() Snacks.zen() end,            desc = "Toggle Zen Mode" },
		{ "<leader>Z", function() Snacks.zen.zoom() end,       desc = "Toggle Zoom" },
		{ "<leader>.", function() Snacks.scratch() end,        desc = "Toggle Scratch Buffer" },
		{ "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
	}
}
