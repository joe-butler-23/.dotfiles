return {
  {
    "Vigemus/iron.nvim",
    config = function()
      local iron = require("iron.core")
      local view = require("iron.view")
      local common = require("iron.fts.common")

      iron.setup({
        config = {
          scratch_repl = true,
          repl_definition = {
            sh = {
              command = { "zsh" },
            },
            python = {
              command = { "python3" }, -- or { "ipython", "--no-autoindent" }
              format = common.bracketed_paste_python,
              block_deviders = { "# %%", "#%%" },
            },
          },
          repl_filetype = function(bufnr, ft)
            return ft
            -- Alternatively, you could return a fixed filetype such as:
            -- return "iron"
          end,
          repl_open_cmd = view.split.vertical.botright(0.4),
        },
        keymaps = {
          toggle_repl = "<space>ir", -- toggles the repl open and closed.
          restart_repl = "<space>iR", -- restarts the repl
          send_motion = "<space>ic",
          visual_send = "<space>iv",
          send_file = "<space>if",
          send_line = "<space>il",
          send_paragraph = "<space>ip",
          send_until_cursor = "<space>iu",
          send_mark = "<space>im",
          send_code_block = "<space>ib",
          send_code_block_and_move = "<space>in",
          mark_motion = "<space>iM",
          mark_visual = "<space>iV",
          remove_mark = "<space>iD",
          cr = "<space>s<cr>",
          interrupt = "<space>s<space>",
          exit = "<space>sq",
          clear = "<space>cl",
          -- If you need keymaps for multiple repl commands, they would be defined here as well.
        },
        highlight = {
          italic = true,
        },
        ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
      })

      -- Additional key mappings for iron.nvim commands
      vim.keymap.set("n", "<space>if", "<cmd>IronFocus<cr>")
      vim.keymap.set("n", "<space>ih", "<cmd>IronHide<cr>")
    end,
  },
}
