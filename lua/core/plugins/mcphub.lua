return {
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Ensure CopilotChat is available so the extension can register functions
      "CopilotC-Nvim/CopilotChat.nvim",
    },
    build = "npm install -g mcp-hub@latest",
    cmd = { "MCPHubToggle", "MCPHubOpen" },
    event = "VeryLazy",
    opts = {
      port = 37373,
      shutdown_delay = 5 * 60 * 1000,
      mcp_request_timeout = 60000,
      workspace = {
        enabled = true,
        look_for = { ".mcphub/servers.json", ".vscode/mcp.json", ".cursor/mcp.json" },
        reload_on_dir_changed = true,
        port_range = { min = 40000, max = 41000 },
      },
      auto_approve = false,
      auto_toggle_mcp_servers = true,
      builtin_tools = {
        edit_file = {
          parser = { track_issues = true, extract_inline_content = true },
          locator = { enable_fuzzy_matching = true, fuzzy_threshold = 0.8 },
        },
      },
      -- CopilotChat extension to expose MCP tools/resources
      extensions = {
        copilotchat = {
          enabled = true,
          convert_tools_to_functions = true,
          convert_resources_to_functions = true,
          add_mcp_prefix = false,
        },
      },
      ui = {
        window = {
          width = 0.8,
          height = 0.8,
          align = "center",
          border = "rounded",
          relative = "editor",
          zindex = 50,
        },
        wo = { winhl = "Normal:MCPHubNormal,FloatBorder:MCPHubBorder" },
      },
      on_ready = function()
        vim.notify("[mcphub] ready", vim.log.levels.INFO)
      end,
      on_error = function(err)
        vim.notify("[mcphub] error: " .. err, vim.log.levels.ERROR)
      end,
      global_env = function(ctx)
        local env = { "DBUS_SESSION_BUS_ADDRESS" }
        if ctx.is_workspace_mode then
          env.WORKSPACE_ROOT = ctx.workspace_root
        end
        return env
      end,
    },
  },
}
