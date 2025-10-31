return {
  "ahmedkhalf/project.nvim",
  config = function()
    require("project_nvim").setup({
      manual_mode = true, -- Disable automatic project detection
      patterns = { ".gitignore", ".nvimroot" },
      ignore_lsp = { "Msc" },
      exclude_dirs = { "~/Msc" }, -- Use .gitignore to detect projects
    })
  end,
}
