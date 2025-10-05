local M = { "lervag/vimtex" }

M.lazy = false

M.init = function()
  vim.g.tex_flavor = "latex"
  vim.g.vimtex_indent_enabled = 0
  vim.g.vimtex_view_method = "zathura"
  vim.g.vimtex_view_automatic = 1
  vim.g.vimtex_quickfix_open_on_warning = 0

  local opts = { noremap = true, silent = true }
  vim.api.nvim_set_keymap("n", "<localleader>vi", ":VimtexInfo<CR>", opts)
  vim.api.nvim_set_keymap("n", "<localleader>vt", ":VimtexTocToggle<CR>", opts)
  vim.api.nvim_set_keymap("n", "<localleader>vq", ":VimtexLog<CR>", opts)
  vim.api.nvim_set_keymap("n", "<localleader>vv", ":VimtexView<CR>", opts)
  vim.api.nvim_set_keymap("n", "<localleader>vl", ":VimtexCompile<CR>", opts)
  vim.api.nvim_set_keymap("n", "<localleader>vk", ":VimtexStop<CR>", opts)
  vim.api.nvim_set_keymap("n", "<localleader>ve", ":VimtexErrors<CR>", opts)
  vim.api.nvim_set_keymap("n", "<localleader>vc", ":VimtexClean<CR>", opts)
  vim.api.nvim_set_keymap("n", "<C-LeftMouse>", ":VimtexView<CR>", { noremap = true, silent = true })
end

return { M }
