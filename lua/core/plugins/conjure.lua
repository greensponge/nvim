local M = {
  "Olical/conjure",
  ft = { "clojure", "fennel", "lua" },
  lazy = true,
}

M.config = function()
  require("conjure.main").main()
  require("conjure.mapping")["on-filetype"]()

  vim.g["conjure#log#wrap"] = true
  vim.g["conjure#highlight#enabled"] = true
  vim.g["conjure#log#hud#width"] = 0.52
  vim.g["conjure#log#hud#width"] = 0.4
  vim.g["conjure#log#botright"] = true
  vim.g["conjure#jump_to_latest#enabled"] = true
  vim.g["conjure#log#hud#border"] = "rounded"
end

return M
