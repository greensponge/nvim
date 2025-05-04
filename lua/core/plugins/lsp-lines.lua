return {
  "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  config = function()
    local lsp_lines = require("lsp_lines")
    lsp_lines.setup()

    -- Disable virtual_text since it's redundant due to lsp_lines.
    vim.diagnostic.config({
      virtual_text = false,
    })

    vim.keymap.set(
      "",
      "<Leader>ll",
      lsp_lines.toggle,
      { desc = "Toggle lsp_lines" }
    )
  end
}
