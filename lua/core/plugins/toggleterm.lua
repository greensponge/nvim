return {
  'akinsho/toggleterm.nvim',
  version = "*",
  opts = {
    direction = 'float',
    open_mapping = [[<C-t>]],
    shell = vim.loop.os_uname().sysname == "Windows_NT" and "powershell" or vim.o.shell, -- Use PowerShell on Windows
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
