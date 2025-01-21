return {
  'saghen/blink.cmp',
  dependencies = 'rafamadriz/friendly-snippets',
  version = '*',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'default',
      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },
      ['<Enter>'] = { 'accept', 'fallback' },
      ['<C-v>'] = { 'show', 'show_documentation', 'hide_documentation' },
    },
    completion = {
      trigger = { show_on_keyword = true },
      menu = {
        auto_show = function(ctx)
          return ctx.mode ~= "cmdline" or not vim.tbl_contains({ ':', '/', '?' }, vim.fn.getcmdtype())
        end,
      },
    },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono'
    },

    signature = { enabled = true }
  },
  opts_extend = { "sources.default" }
}
