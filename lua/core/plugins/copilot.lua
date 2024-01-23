return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	config = function()
		require("copilot").setup({
			-- use copilot-cmp instead of built-in suggestions, these otherwise interfere with completions
			panel = { enabled = false, },
			suggestion = { enabled = false }
		})
	end
}
