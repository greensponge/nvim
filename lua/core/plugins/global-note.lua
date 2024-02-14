return {
	"backdround/global-note.nvim",
	config = function()
		local global_note = require("global-note")
		vim.keymap.set("n", "<leader>n", global_note.toggle_note, { desc = "Toggle global note" })
	end
}
