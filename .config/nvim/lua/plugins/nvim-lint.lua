return {
  {
    "mfussenegger/nvim-lint",
    enabled = true,
    event = "VeryLazy",
    config = function()
      require("lint").linters_by_ft = {
        markdown = { "markdownlint", "vale" },
        yaml = { "yamllint" },
        text = { "vale" },
        tex = { "vale" },
        latex = { "vale" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
}
