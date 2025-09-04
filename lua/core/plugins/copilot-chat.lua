return {
  "CopilotC-Nvim/CopilotChat.nvim",
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim",                  branch = "master" },
    { "nvim-telescope/telescope.nvim" },
    { "nvim-telescope/telescope-ui-select.nvim" },
    -- (Optional) If you want MCP available before chat opens:
    { "ravitemer/mcphub.nvim" },
  },
  build = "make tiktoken",
  init = function()
    -- Telescope ui-select
    local ok, telescope = pcall(require, "telescope")
    if ok then
      telescope.setup({
        extensions = { ["ui-select"] = require("telescope.themes").get_dropdown({}) },
      })
      pcall(telescope.load_extension, "ui-select")
    end

    -- Highlight groups (tweak to taste)
    local set = vim.api.nvim_set_hl
    local palette = {
      sep = "#374151",
      header = "#A3D9FF",
      model = "#C678DD",
      prompt = "#61AFEF",
      tool = "#98C379",
      res = "#E5C07B",
      uri = "#56B6C2",
      sel = "#264F78",
      ann = "#7F848E",
    }
    set(0, "CopilotChatSeparator", { fg = palette.sep })
    set(0, "CopilotChatHeader", { fg = palette.header, bold = true })
    set(0, "CopilotChatModel", { fg = palette.model, italic = true })
    set(0, "CopilotChatPrompt", { fg = palette.prompt })
    set(0, "CopilotChatTool", { fg = palette.tool })
    set(0, "CopilotChatResource", { fg = palette.res })
    set(0, "CopilotChatUri", { fg = palette.uri, underline = true })
    set(0, "CopilotChatSelection", { bg = palette.sel })
    set(0, "CopilotChatStatus", { fg = palette.prompt })
    set(0, "CopilotChatHelp", { fg = "#6B7280" })
    set(0, "CopilotChatAnnotation", { fg = palette.ann })

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
      "Now answer:",
    }, "\n")

    return {
      model = "gpt-4.1",
      temperature = 0.1,
      auto_insert_mode = true,
      window = { layout = "vertical", width = 0.45 },

      prompts = {
        AlwaysGuide = {
          description = "AlwaysGuide system prompt",
          system_prompt = system_prompt,
        },
        ExplainSelection = {
          description = "Explain current selection",
          prompt = "#selection Explain this code",
        },
        ReviewBuffer = {
          description = "Review whole buffer for issues",
          prompt = "#buffer Review this file for bugs, edge cases and improvements.",
        },
        ProjectAware = {
          description = "Answer using project context when possible",
          system_prompt = "You have access to referenced project files. Prefer direct, minimal answers.",
        },
      },

      functions = {
        birthday = {
          description = "Retrieve birthday info",
          uri = "birthday://{name}",
          schema = {
            type = "object",
            required = { "name" },
            properties = {
              name = {
                type = "string",
                enum = { "Alice", "Bob", "Charlie" },
                description = "Person's name",
              },
            },
          },
          resolve = function(input)
            return {
              {
                uri = "birthday://" .. input.name,
                mimetype = "text/plain",
                data = input.name .. " birthday info",
              },
            }
          end,
        },
      },
    }
  end,
  keys = function()
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

    local function add_workspace_readme()
      -- Example helper: add README.* if exists
      local cwd = vim.loop.cwd()
      local candidates = { "README.md", "README.txt", "readme.md" }
      for _, f in ipairs(candidates) do
        local full = cwd .. "/" .. f
        if vim.loop.fs_stat(full) then
          add_sticky("#file:" .. full)
        end
      end
    end

    return {
      { "<leader>cc", function() require("CopilotChat").toggle() end,                         desc = "CopilotChat: Toggle" },
      { "<leader>cr", function() require("CopilotChat").reset() end,                          desc = "CopilotChat: Reset" },
      { "<leader>ca", function() require("CopilotChat").ask("#buffer Explain this code") end, mode = { "n", "v" },                        desc = "CopilotChat: Ask (buffer/selection)" },
      { "<leader>cm", function() require("CopilotChat").select_model() end,                   desc = "CopilotChat: Models" },
      { "<leader>cp", function() require("CopilotChat").select_prompt() end,                  desc = "CopilotChat: Prompts" },
      { "<leader>cs", ":CopilotChatAlwaysGuide<CR>",                                          desc = "CopilotChat: AlwaysGuide" },

      -- Context helpers
      { "<leader>cf", add_current_file_sticky,                                                desc = "CopilotChat: Add current file" },
      { "<leader>cF", pick_file_and_add_sticky,                                               desc = "CopilotChat: Pick file to add" },
      { "<leader>cB", function() add_sticky("#buffer") end,                                   desc = "CopilotChat: Add buffer" },
      { "<leader>cS", function() add_sticky("#selection") end,                                mode = { "v" },                             desc = "CopilotChat: Add selection" },
      { "<leader>cR", add_workspace_readme,                                                   desc = "CopilotChat: Add README if present" },
    }
  end,
}
