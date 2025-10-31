return {
  "rickhowe/diffchar.vim",
  event = "BufRead",
  config = function()
    vim.g.DiffUnit = "[.!?]"
    vim.g.DiffColors = 2
    vim.g.DiffPairVisible = 1
    local opts = { noremap = false, silent = true }

    -- Navigate between diffchar units
    vim.api.nvim_set_keymap("n", "<localleader>n", "<Plug>JumpDiffCharNextStart", opts)
    vim.api.nvim_set_keymap("n", "<localleader>p", "<Plug>JumpDiffCharPrevStart", opts)
    vim.api.nvim_set_keymap("n", "<localleader>N", "<Plug>JumpDiffCharNextEnd", opts)
    vim.api.nvim_set_keymap("n", "<localleader>P", "<Plug>JumpDiffCharPrevEnd", opts)

    -- Get and put diff units
    vim.api.nvim_set_keymap("n", "<localleader>g", "<Plug>GetDiffCharPair", opts)
    vim.api.nvim_set_keymap("n", "<localleader>u", "<Plug>PutDiffCharPair", opts)
  end,
}
