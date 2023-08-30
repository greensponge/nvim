local M = {
  "Olical/conjure",
  ft = { "clojure", "fennel", "lua" },
  lazy = true,
  -- [Optional] cmp-conjure for cmp
  dependencies = {
    {
      "PaterJason/cmp-conjure",
      config = function()
        local cmp = require("cmp")
        local config = cmp.get_config()
        table.insert(config.sources, {
          name = "buffer",
          option = {
            sources = {
              { name = "conjure" },
            },
          },
        })
        cmp.setup(config)
      end,
    },
  }
}

M.config = function()
  require("conjure.main").main()
  require("conjure.mapping")["on-filetype"]()

  vim.g["conjure#log#wrap"] = true
  vim.g["conjure#highlight#enabled"] = true
  vim.g["conjure#log#hud#width"] = 0.52
  vim.g["conjure#log#hud#width"] = 0.4
  vim.g["conjure#jump_to_latest#enabled"] = true
  vim.g["conjure#log#hud#border"] = "rounded"
end

return M
