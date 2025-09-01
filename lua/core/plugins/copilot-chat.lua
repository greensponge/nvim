return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    event = "VeryLazy",
    dependencies = {
      { "nvim-lua/plenary.nvim",                  branch = "master" },
      { "nvim-telescope/telescope.nvim" },
      { "nvim-telescope/telescope-ui-select.nvim" },
    },
    build = "make tiktoken",
    init = function()
      -- Use Telescope as vim.ui.select
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

      local function ensure_chat_and_focus()
        local chat = require("CopilotChat")
        if not chat.chat:visible() then chat.open() end
        chat.chat:focus()
        return chat
      end

      local function add_sticky(line)
        local chat = ensure_chat_and_focus()
        chat.chat:add_sticky(line)
      end

      local function add_current_file_sticky()
        local path = vim.api.nvim_buf_get_name(0)
        if path == nil or path == "" then return end
        add_sticky("#file:" .. path)
      end

      local function pick_file_and_add_sticky()
        local ok_builtin, builtin = pcall(require, "telescope.builtin")
        if not ok_builtin then return end
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        builtin.find_files({
          attach_mappings = function(_, map)
            local function on_select(prompt_bufnr)
              local entry = action_state.get_selected_entry()
              actions.close(prompt_bufnr)
              local p = entry.path or entry.value
              add_sticky("#file:" .. p)
            end
            map("i", "<CR>", on_select)
            map("n", "<CR>", on_select)
            return true
          end,
        })
      end

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

        -- Add resources to chat as sticky context
        { "<leader>cf", add_current_file_sticky,                               desc = "CopilotChat: Add current file as context" },
        { "<leader>cF", pick_file_and_add_sticky,                              desc = "CopilotChat: Pick file to add as context" },
        { "<leader>cB", function() add_sticky("#buffer") end,                  desc = "CopilotChat: Add current buffer as context" },
        { "<leader>cS", function() add_sticky("#selection") end,               mode = { "v" },                                     desc = "CopilotChat: Add visual selection as context" },
      }
    end,
  },
}
