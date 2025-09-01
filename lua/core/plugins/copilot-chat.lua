return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    event = "VeryLazy",
    dependencies = {
      { "nvim-lua/plenary.nvim",                  branch = "master" },
      { "nvim-telescope/telescope.nvim" },
      { "nvim-telescope/telescope-ui-select.nvim" },
    },
    -- Linux: keep tiktoken build for accurate token counting
    build = "make tiktoken",
    init = function()
      -- Enable Telescope as vim.ui.select provider
      local ok, telescope = pcall(require, "telescope")
      if ok then
        telescope.setup({
          extensions = {
            ["ui-select"] = require("telescope.themes").get_dropdown({}),
          },
        })
        pcall(telescope.load_extension, "ui-select")
      end

      -- Chat buffer tweaks
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-*",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
          vim.opt_local.conceallevel = 0
        end,
      })
    end,
    opts = function()
      local system_prompt = table.concat({
        "Before answering, work through this step-by-step:",
        "",
        "1. UNDERSTAND: What is the core question being asked?",
        "2. ANALYZE: What are the key factors/components involved?",
        "3. REASON: What logical connections can I make?",
        "4. SYNTHESIZE: How do these elements combine?",
        "5. CONCLUDE: What is the most accurate/helpful response?",
        "",
        "Now answer: ",
      }, "\n")

      return {
        model = "gpt-4.1",
        temperature = 0.1,
        auto_insert_mode = true,
        window = { layout = "vertical", width = 0.45 },

        -- Optional: a callable prompt that uses your system prompt
        prompts = {
          AlwaysGuide = {
            description = "Chat with the AlwaysGuide system prompt",
            system_prompt = system_prompt,
          },
        },
      }
    end,
    keys = function()
      local system_prompt = table.concat({
        "Before answering, work through this step-by-step:",
        "",
        "1. UNDERSTAND: What is the core question being asked?",
        "2. ANALYZE: What are the key factors/components involved?",
        "3. REASON: What logical connections can I make?",
        "4. SYNTHESIZE: How do these elements combine?",
        "5. CONCLUDE: What is the most accurate/helpful response?",
        "",
        "Now answer: ",
      }, "\n")

      return {
        { "<leader>cc", function() require("CopilotChat").toggle() end, desc = "CopilotChat: Toggle" },
        {
          "<leader>co",
          function()
            local chat = require("CopilotChat")
            chat.open()
            chat.chat:add_sticky(system_prompt)
          end,
          desc = "CopilotChat: Open (with system prompt)",
        },
        { "<leader>cr", function() require("CopilotChat").reset() end,  desc = "CopilotChat: Reset" },
        {
          "<leader>ca",
          function() require("CopilotChat").ask("#buffer Explain this code") end,
          mode = { "n", "v" },
          desc = "CopilotChat: Ask (buffer/selection)",
        },
        { "<leader>cm", function() require("CopilotChat").select_model() end,  desc = "CopilotChat: Models (Telescope)" },
        { "<leader>cp", function() require("CopilotChat").select_prompt() end, desc = "CopilotChat: Prompts (Telescope)" },
        { "<leader>cs", ":CopilotChatAlwaysGuide<CR>",                         desc = "CopilotChat: AlwaysGuide prompt" },
      }
    end,
  },
}
