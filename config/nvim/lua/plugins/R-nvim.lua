return {
  {
    "R-nvim/R.nvim",
    lazy = false,
    version = "~0.1.0",
    opts = {
      R_args = { "--quiet", "--no-save" },
      setwd = "file",
      pdfviewer = "zathura", -- Or your preferred viewer
      external_term = "/usr/bin/kitten @ --to unix:/tmp/kitty_sock launch --type=os-window --location=vsplit --keep-focus --cwd=current",
      pipe_keymap = "", -- Disable default pipe keybinding,
      user_maps_only = true,
      hook = {
        on_filetype = function()
          -- R Session Management
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<Space>rs",
            "<Cmd>lua require('r.run').start_R('R')<CR>",
            { noremap = true, silent = true, desc = "Start R" }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<leader>rq",
            "<Cmd>lua require('r.run').quit_R('save')<CR>",
            { noremap = true, silent = true, desc = "Quit R (save workspace)" }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<Space>r!",
            "<Cmd>lua require('r.run').quit_R('nosave')<CR>",
            { noremap = true, silent = true, desc = "Quit R (no save)" }
          )

          -- R Weaving (Knitting, Sweaving, Quarto)
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<Space>rkk",
            "<Cmd>lua require('r.send').cmd(\"rmarkdown::run('" .. vim.fn.expand("%:p") .. "')\")<CR>",
            { noremap = true, silent = true, desc = "Run R Markdown interactively" }
          )

          -- Set the browser option to open in a new Brave window
          require("r.send").cmd("options(browser = '/usr/bin/brave --new-window')")

          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<Space>rko",
            "<Cmd>lua require('r.rmd').make('odt')<CR>",
            { noremap = true, silent = true, desc = "Generate ODT" }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<Space>rkp",
            "<Cmd>lua require('r.rmd').make('pdf_document')<CR>",
            { noremap = true, silent = true, desc = "Generate PDF" }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<Space>rkw",
            "<Cmd>lua require('r.rmd').make('word_document')<CR>",
            { noremap = true, silent = true, desc = "Generate Word" }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<Space>rkh",
            "<Cmd>lua require('r.rmd').make('html_document')<CR>",
            { noremap = true, silent = true, desc = "Generate HTML" }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<Space>rka",
            "<Cmd>lua require('r.rmd').make('all')<CR>",
            { noremap = true, silent = true, desc = "Generate all formats" }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<Space>rkq",
            "<Cmd>lua require('r.quarto').command('preview')<CR>",
            { noremap = true, silent = true, desc = "Quarto Preview" }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<Space>rkQ",
            "<Cmd>lua require('r.quarto').command('stop')<CR>",
            { noremap = true, silent = true, desc = "Stop Quarto Preview" }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<Space>rkr",
            "<Cmd>lua require('r.quarto').command('render')<CR>",
            { noremap = true, silent = true, desc = "Render Quarto document" }
          )

          -- Sending Code to R
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<Space>rc",
            "<Cmd>lua require('r.rmd').send_R_chunk(false)<CR>",
            { noremap = true, silent = true, desc = "Send current chunk" }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<Space>rl",
            "<Cmd>lua require('r.send').line(false)<CR>",
            { noremap = true, silent = true, desc = "Send current line" }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<Space>rp",
            "<Cmd>lua require('r.send').paragraph(false)<CR>",
            { noremap = true, silent = true, desc = "Send paragraph" }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "v",
            "<Space>rv",
            "<Cmd>lua require('r.send').selection(false)<CR>",
            { noremap = true, silent = true, desc = "Send selection (visual mode)" }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<Space>rC",
            "<Cmd>lua require('r.send').chain()<CR>",
            { noremap = true, silent = true, desc = "Send piped commands" }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<Space>rf",
            "<Cmd>lua require('r.send').funs(0, false, false)<CR>",
            { noremap = true, silent = true, desc = "Send function" }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<Space>rA",
            "<Cmd>lua require('r.send').funs(0, true, false)<CR>",
            { noremap = true, silent = true, desc = "Send all functions" }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<Space>rB",
            "<Cmd>lua require('r.send').marked_block(false)<CR>",
            { noremap = true, silent = true, desc = "Send marked block" }
          )

          -- R Code Navigation
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<Space>rn",
            "<Cmd>lua require('r.rmd').next_chunk()<CR>",
            { noremap = true, silent = true, desc = "Next R chunk" }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<Space>rN",
            "<Cmd>lua require('r.rmd').previous_chunk()<CR>",
            { noremap = true, silent = true, desc = "Previous R chunk" }
          )

          -- R Object Inspection
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<Space>ro",
            "<Cmd>lua require('r.browser').start()<CR>",
            { noremap = true, silent = true, desc = "Toggle Object Browser" }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<Space>rM",
            "<Cmd>lua require('r.run').action('viewobj')<CR>",
            { noremap = true, silent = true, desc = "View data.frame/matrix" }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<Space>rE",
            "<Cmd>lua require('r.run').action('example')<CR>",
            { noremap = true, silent = true, desc = "Show examples" }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<Space>rH",
            "<Cmd>lua require('r.run').action('help')<CR>",
            { noremap = true, silent = true, desc = "Show help" }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<Space>rO",
            "<Cmd>lua require('r.run').action('str')<CR>",
            { noremap = true, silent = true, desc = "Show object structure" }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<Space>rP",
            "<Cmd>lua require('r.run').action('print')<CR>",
            { noremap = true, silent = true, desc = "Print object" }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<Space>rS",
            "<Cmd>lua require('r.run').action('summary')<CR>",
            { noremap = true, silent = true, desc = "Show summary" }
          )

          -- R File & Environment Management
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<Space>rD",
            "<Cmd>lua require('r.run').setwd()<CR>",
            { noremap = true, silent = true, desc = "Set working directory" }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<Space>rm",
            "<Cmd>lua require('r.run').clear_all()<CR>",
            { noremap = true, silent = true, desc = "Clear environment" }
          )
          vim.api.nvim_buf_set_keymap(
            0,
            "n",
            "<Space>rr",
            "<Cmd>lua require('r.run').clear_console()<CR>",
            { noremap = true, silent = true, desc = "Clear console" }
          )

          -- Set browser option for R
          require("r.send").cmd("options(browser = '/usr/bin/brave --new-window')")
        end,
      },
    },
  },
  {
    "quarto-dev/quarto-nvim",
    dependencies = { "jmbuhr/otter.nvim" },
    config = function()
      require("quarto").setup()
    end,
  },
}
