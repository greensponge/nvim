return {
  "CopilotC-Nvim/CopilotChat.nvim",
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim",        branch = "master" },
    { "nvim-telescope/telescope.nvim" },
    -- If you want MCP available before chat opens:
    { "ravitemer/mcphub.nvim" },
  },
  build = "make tiktoken",
  init = function()
    -- Highlight groups (tweak to taste)
    local set = vim.api.nvim_set_hl
    local palette = {
      sep    = "#6e738d", -- surface2
      header = "#f5e0dc", -- rosewater
      model  = "#cba6f7", -- mauve
      prompt = "#89b4fa", -- blue
      tool   = "#a6e3a1", -- green
      res    = "#f9e2af", -- yellow
      uri    = "#74c7ec", -- sapphire
      sel    = "#313244", -- surface0
      ann    = "#9399b2", -- overlay1
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
    return {
      model = "gpt-4.1",
      temperature = 0.1,
      auto_insert_mode = true,
      window = { layout = "vertical", width = 0.45 },

      prompts = {
        ImprovedPromptResults = {
          description = "AlwaysGuide system prompt",
          system_prompt = [[
Before answering, work through this step-by-step:
1. UNDERSTAND: What is the core question being asked?
2. ANALYZE: What are the key factors/components involved?
3. REASON: What logical connections can I make?
4. SYNTHESIZE: How do these elements combine?
5. CONCLUDE: What is the most accurate/helpful response?

Now answer:
          ]]
        },
        OptimizedPromptConsult = {
          description = "Prompt engineering consultant: optimize a prompt using best practices",
          prompt = [[
{input}

You are a senior prompt engineering consultant specializing in LLM optimization, with expertise in the current model's latest best practices and techniques. Your role is to transform prompts into high-performance, structured instructions that maximize LLM's effectiveness.

<objective>
Analyze the provided prompt and create an optimized version that incorporates proven prompt engineering techniques including clear role definition, XML structure, multishot examples, and measurable success criteria.
</objective>

<methodology>
<thinking>
First, analyze the current prompt structure step-by-step:
1. Identify the core task and intended outcome
2. Assess clarity and specificity of instructions
3. Evaluate structure and organization
4. Check for missing elements (examples, output format, success criteria)
5. Note opportunities for improvement using best practices
</thinking>

Follow this systematic approach:
1. **Research Phase**: Gather relevant best practices from Anthropic documentation (use WebFetch tool for current guidelines)
2. **Analysis Phase**: Identify specific issues and improvement opportunities
3. **Design Phase**: Apply best practices including:
   - Clear role definition and context
   - XML tags for structure
   - Specific, measurable success criteria
   - Multishot examples where applicable
   - Chain-of-thought guidance for complex tasks
4. **Validation Phase**: Review against quality criteria
</methodology>

<output_format>
Provide your response in this exact structure:

<analysis>
[Your analysis of the current prompt's strengths and weaknesses]
</analysis>

<improved_prompt>
[The optimized prompt using best practices]
</improved_prompt>

<improvements_applied>
[List of specific improvements made and why]
</improvements_applied>

<success_criteria>
[Measurable criteria for evaluating the improved prompt's effectiveness]
</success_criteria>
</output_format>

<quality_standards>
- Instructions must be specific and actionable
- Structure should use XML tags for clarity
- Include relevant examples when beneficial
- Define clear success metrics
- Optimize for the intended use case and audience
</quality_standards>
          ]],
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
      chat.chat:append(line .. "\n\n")
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
