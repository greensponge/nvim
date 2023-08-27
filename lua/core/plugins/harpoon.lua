local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
local map = vim.keymap.set

map("n", "<leader>h", mark.add_file, {desc = "Harpoon a file for later navigation. Unique bindings per project."})
map("n", "<C-e>", ui.toggle_quick_menu, {desc = "Shows the Harpoon quick menu."})
map("n", "<C-h>", function() ui.nav_file(1) end)
map("n", "<C-t>", function() ui.nav_file(2) end)
map("n", "<C-v>", function() ui.nav_file(3) end)
map("n", "<C-s>", function() ui.nav_file(4) end)

return {
    'ThePrimeagen/harpoon'
}
