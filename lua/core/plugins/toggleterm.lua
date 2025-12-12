return {
  'akinsho/toggleterm.nvim',
  version = "*",
  opts = {
    direction = 'float',
    open_mapping = [[<C-t>]],
    shell = (vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1) and
        (vim.fn.executable('pwsh') == 1 and 'pwsh' or 'powershell') or vim.o.shell, -- Use PowerShell only on native Windows
  },
  keys = {
    {
      "<leader>tv",
      function()
        local count = vim.v.count1
        require("toggleterm").toggle(count, 0, vim.loop.cwd(), "vertical")
      end,
      desc = "ToggleTerm (vertical)",
    },
    {
      "<leader>th",
      function()
        local count = vim.v.count1
        require("toggleterm").toggle(count, 10, vim.loop.cwd(), "horizontal")
      end,
      desc = "ToggleTerm (horizontal)",
    }
  },
  config = true
}
