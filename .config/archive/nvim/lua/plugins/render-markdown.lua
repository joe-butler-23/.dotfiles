return {
  "MeanderingProgrammer/render-markdown.nvim",
  config = function()
    -- Setup with custom highlights
    require("render-markdown").setup({
      highlights = {
        code = "MarkdownCodeBlock",
      },
    })

    -- Define custom highlight for code blocks
    vim.api.nvim_set_hl(0, "MarkdownCodeBlock", {
      bg = "#1e1e2e", -- dark background
      fg = "#cdd6f4", -- light foreground
    })

    -- Associate .Rmd with markdown rendering
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "rmd",
      callback = function()
        require("render-markdown").render()
      end,
    })
  end,
  ft = { "markdown", "rmd", "codecompanion" }, -- ensure it loads for .md and .Rmd files
}
