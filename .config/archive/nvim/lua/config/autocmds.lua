-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWinEnter" }, {
  pattern = { "*.tex", "*.rmd" }, -- Use file patterns instead of filetype when using BufReadPost/BufWinEnter
  callback = function()
    if vim.bo.filetype == "tex" or vim.bo.filetype == "rmd" then
      vim.opt_local.wrap = true
      vim.opt_local.linebreak = true
    end
  end,
})

-- Define a command to run wdiff
vim.api.nvim_create_user_command("Wdiff", function(opts)
  if #opts.fargs < 2 then
    print("Usage: Wdiff file1 file2")
    return
  end

  local file1 = opts.fargs[1]
  local file2 = opts.fargs[2]

  -- Create a new buffer with the wdiff output
  vim.cmd("new")
  vim.cmd("setlocal buftype=nofile")
  vim.cmd("setlocal bufhidden=wipe")
  vim.cmd("setlocal noswapfile")
  vim.cmd("setlocal nowrap")
  vim.cmd("file Wdiff\\ Result")

  -- Run wdiff and put output in the buffer
  vim.fn.termopen("wdiff " .. vim.fn.shellescape(file1) .. " " .. vim.fn.shellescape(file2))
end, {
  nargs = "+",
  complete = "file",
})

-- Highlight settings for wdiff output
vim.cmd([[
  augroup WdiffHighlight
    autocmd!
    autocmd BufNewFile,BufRead Wdiff\ Result highlight WdiffDelete ctermfg=red guifg=red
    autocmd BufNewFile,BufRead Wdiff\ Result highlight WdiffAdd ctermfg=green guifg=green
    autocmd BufNewFile,BufRead Wdiff\ Result syntax match WdiffDelete /\[-.\{-}-\]/
    autocmd BufNewFile,BufRead Wdiff\ Result syntax match WdiffAdd /{\+.\{-}+}/
  augroup END
]])
