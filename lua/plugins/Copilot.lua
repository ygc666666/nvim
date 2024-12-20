-- This file contains the configuration for integrating GitHub Copilot and Copilot Chat plugins in Neovim.

-- Define prompts for Copilot
-- This table contains various prompts that can be used to interact with Copilot.
local prompts = {
  Explain = "请解释以下代码的工作原理。", -- 解释代码的提示
  Review = "请审查以下代码并提供改进建议。", -- 审查代码的提示
  Tests = "请解释所选代码的工作原理，然后为其生成单元测试。", -- 生成单元测试的提示
  Refactor = "请重构以下代码以提高其清晰度和可读性。", -- 重构代码的提示
  FixCode = "请修复以下代码以使其按预期工作。", -- 修复代码的提示
  FixError = "请解释以下文本中的错误并提供解决方案。", -- 修复错误的提示
  BetterNamings = "请为以下变量和函数提供更好的名称。", -- 提供更好命名的提示
  Documentation = "请为以下代码提供文档。", -- 生成文档的提示
  JsDocs = "请为以下代码提供 JsDocs。", -- 生成 JsDocs 的提示
  DocumentationForGithub = "请为以下代码提供适用于 GitHub 的 Markdown 文档。", -- 生成 GitHub 文档的提示
  CreateAPost = "请为以下代码提供文档，以便在社交媒体（如 LinkedIn）上发布，要求内容深入、解释清晰且易于理解，同时有趣且引人入胜。", -- 创建社交媒体帖子的提示
  SwaggerApiDocs = "请使用 Swagger 为以下 API 提供文档。", -- 生成 Swagger API 文档的提示
  SwaggerJsDocs = "请使用 Swagger 为以下 API 编写 JSDoc。", -- 生成 Swagger JsDocs 的提示
  Summarize = "请总结以下文本。", -- 总结文本的提示
  Spelling = "请纠正以下文本中的语法和拼写错误。", -- 纠正拼写和语法错误的提示
  Wording = "请改进以下文本的语法和措辞。", -- 改进措辞的提示
  Concise = "请将以下文本改写得更简洁。", -- 使文本简洁的提示
}
  
  -- Plugin configuration
  -- This table contains the configuration for various plugins used in Neovim.

return {
  -- GitHub Copilot 插件
  { "github/copilot.vim" }, -- 加载 GitHub Copilot 插件

  -- Which-key 插件配置
  {
    "folke/which-key.nvim", -- 加载 which-key 插件
    optional = true, -- 该插件是可选的
    opts = {
      spec = {
        { "<leader>a", group = "ai" }, -- 定义 AI 相关命令组
        { "gm", group = "+Copilot chat" }, -- 定义 Copilot 聊天命令组
        { "gmh", desc = "显示帮助" }, -- 显示帮助的快捷键
        { "gmd", desc = "显示差异" }, -- 显示差异的快捷键
        { "gmp", desc = "显示系统提示" }, -- 显示系统提示的快捷键
        { "gms", desc = "显示选择" }, -- 显示选择的快捷键
        { "gmy", desc = "复制差异" }, -- 复制差异的快捷键
      },
    },
  },

  -- Copilot Chat 插件配置
  {
    "CopilotC-Nvim/CopilotChat.nvim", -- 加载 Copilot Chat 插件
    branch = "canary", -- 使用 'canary' 分支
    dependencies = {
      { "nvim-telescope/telescope.nvim" }, -- 依赖 Telescope 插件
      { "nvim-lua/plenary.nvim" }, -- 依赖 Plenary 插件
    },
    opts = {
      question_header = "## 用户 ", -- 用户问题的标题
      answer_header = "## Copilot ", -- Copilot 回答的标题
      error_header = "## 错误 ", -- 错误的标题
      prompts = prompts, -- 使用定义的提示
      auto_follow_cursor = false, -- 禁用自动跟随光标
      show_help = false, -- 默认禁用显示帮助
      mappings = {
        complete = { detail = "使用 @<Tab> 或 /<Tab> 选择选项。", insert = "<Tab>" }, -- 完成的快捷键
        close = { normal = "q", insert = "<C-c>" }, -- 关闭聊天的快捷键
        reset = { normal = "<C-x>", insert = "<C-x>" }, -- 重置聊天的快捷键
        submit_prompt = { normal = "<CR>", insert = "<C-CR>" }, -- 提交提示的快捷键
        accept_diff = { normal = "<C-y>", insert = "<C-y>" }, -- 接受差异的快捷键
        yank_diff = { normal = "gmy" }, -- 复制差异的快捷键
        show_diff = { normal = "gmd" }, -- 显示差异的快捷键
        show_system_prompt = { normal = "gmp" }, -- 显示系统提示的快捷键
        show_user_selection = { normal = "gms" }, -- 显示用户选择的快捷键
        show_help = { normal = "gmh" }, -- 显示帮助的快捷键
      },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")
      local select = require("CopilotChat.select")

      -- 设置默认选择方法
      opts.selection = select.unnamed

      -- 定义提交信息的自定义提示
      opts.prompts.Commit = {
        prompt = "为更改编写符合 commitizen 规范的提交信息",
        selection = select.gitdiff,
      }

      opts.prompts.CommitStaged = {
        prompt = "为更改编写符合 commitizen 规范的提交信息",
        selection = function(source)
          return select.gitdiff(source, true)
        end,
      }

      -- 使用提供的选项设置 Copilot Chat
      chat.setup(opts)
      require("CopilotChat.integrations.cmp").setup()

      -- 创建不同聊天模式的用户命令
      vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
        chat.ask(args.args, { selection = select.visual })
      end, { nargs = "*", range = true })

      vim.api.nvim_create_user_command("CopilotChatInline", function(args)
        chat.ask(args.args, {
          selection = select.visual,
          window = {
            layout = "float",
            relative = "cursor",
            width = 1,
            height = 0.4,
            row = 1,
          },
        })
      end, { nargs = "*", range = true })

      vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
        chat.ask(args.args, { selection = select.buffer })
      end, { nargs = "*", range = true })

      -- 进入 Copilot 缓冲区时设置缓冲区特定选项
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-*",
        callback = function()
          vim.opt_local.relativenumber = true
          vim.opt_local.number = true

          local ft = vim.bo.filetype
          if ft == "copilot-chat" then
            vim.bo.filetype = "markdown"
          end
        end,
      })
    end,
    event = "VeryLazy", -- 在 'VeryLazy' 事件时加载此插件
    keys = {
      {
        "<leader>ah",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.telescope").pick(actions.help_actions())
        end,
        desc = "CopilotChat - 帮助操作",
      },
      {
        "<leader>ap",
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
        end,
        desc = "CopilotChat - 提示操作",
      },
      {
        "<leader>ap",
        ":lua require('CopilotChat.integrations.telescope').pick(require('CopilotChat.actions').prompt_actions({selection = require('CopilotChat.select').visual}))<CR>",
        mode = "x",
        desc = "CopilotChat - 提示操作",
      },
      { "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - 解释代码" },
      { "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - 生成测试" },
      { "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - 代码审查" },
      { "<leader>aR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - 重构代码" },
      { "<leader>an", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - 更好的命名" },
      { "<leader>av", ":CopilotChatVisual", mode = "x", desc = "CopilotChat - 在垂直分割中打开" },
      { "<leader>ax", ":CopilotChatInline<cr>", mode = "x", desc = "CopilotChat - 内联聊天" },
      {
        "<leader>ai",
        function()
          local input = vim.fn.input("询问 Copilot: ")
          if input ~= "" then
              local result = vim.fn.system("copilot-cli chat " .. input)
              if result ~= "" then
                  -- 将生成的代码插入到当前光标位置
                  vim.api.nvim_put({ result }, 'l', true, true)
              end
          end
        end,
        desc = "CopilotChat - 询问输入并插入代码",
      },
      { "<leader>am", "<cmd>CopilotChatCommit<cr>", desc = "CopilotChat - 为所有更改生成提交信息" },
      {
        "<leader>aM",
        "<cmd>CopilotChatCommitStaged<cr>",
        desc = "CopilotChat - 为已暂存的更改生成提交信息",
      },
      {
        "<leader>aq",
        function()
          local input = vim.fn.input("快速聊天: ")
          if input ~= "" then
            vim.cmd("CopilotChatBuffer " .. input)
          end
        end,
        desc = "CopilotChat - 快速聊天",
      },
      { "<leader>ad", "<cmd>CopilotChatDebugInfo<cr>", desc = "CopilotChat - 调试信息" },
      { "<leader>af", "<cmd>CopilotChatFixDiagnostic<cr>", desc = "CopilotChat - 修复诊断" },
      { "<leader>al", "<cmd>CopilotChatReset<cr>", desc = "CopilotChat - 清除缓冲区和聊天历史" },
      { "<leader>av", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - 切换" },
      { "<leader>a?", "<cmd>CopilotChatModels<cr>", desc = "CopilotChat - 选择模型" },
      { "<leader>ac", function()
          local input = vim.fn.input("询问 Copilot: ")
          if input ~= "" then
              vim.cmd("CopilotChat " .. input)
          end
      end, desc = "CopilotChat - 询问输入" },
      { "<leader>cc", function()
          -- 进入可视模式并选中当前选中的内容
          vim.cmd('normal! gv"ay')
          -- 将选中的内容复制到系统剪贴板
          vim.fn.setreg('+', vim.fn.getreg('a'))
      end, desc = "复制选中内容" },
    },
  },
}