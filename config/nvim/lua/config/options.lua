-- ~/.config/nvim/lua/config/options.lua

-- Options are automatically loaded before lazy.nvim startup (if using LazyVim)
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Standard Options
vim.opt.clipboard = "unnamedplus" -- Set clipboard to system clipboard
vim.o.mouse = "a" -- Enable mouse support in all modes
vim.opt.conceallevel = 1 -- Hide * markup for bold/italic in Markdown/Org, etc.

-- Kitty Terminal Integration (Keep if you use Kitty)
vim.api.nvim_create_autocmd({ "VimEnter", "VimResume" }, {
  group = vim.api.nvim_create_augroup("UserKittySetVarVimEnter", { clear = true }),
  callback = function()
    -- Sets kitty user var in_editor=1 when vim starts/resumes
    io.stdout:write("\x1b]1337;SetUserVar=in_editor=MQo\a") -- MQo is base64 for '1'
  end,
})

vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
  group = vim.api.nvim_create_augroup("UserKittyUnsetVarVimLeave", { clear = true }),
  callback = function()
    -- Unsets kitty user var in_editor when vim leaves/suspends
    io.stdout:write("\x1b]1337;SetUserVar=in_editor\a")
  end,
})

-- Treesitter Language Registration (Example for RMD)
-- Ensure 'markdown' parser is installed via nvim-treesitter
vim.treesitter.language.register("markdown", "rmd")

-- Custom Highlighting (Example for RMD)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rmd",
  group = vim.api.nvim_create_augroup("UserRmdHighlights", { clear = true }),
  callback = function()
    -- Example: Highlight RMD code blocks differently
    -- Adjust colors '#3A2E3F' (background) and '#c8d3f5' (foreground) as needed
    vim.cmd([[
      highlight RmdCodeBlock guibg=#3A2E3F guifg=#c8d3f5
      highlight link @text.literal.markdown RmdCodeBlock
      highlight link @text.literal.markdown_inline RmdCodeBlock
    ]])
  end,
})

-- LSP Inlay Hints Autocommand (Corrected)
-- Disables inlay hints upon entering valid, normal buffers
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*", -- Apply to all buffers
  group = vim.api.nvim_create_augroup("UserLspInlayHints", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    if not vim.api.nvim_buf_is_valid(bufnr) then
      return
    end
    if not vim.api.nvim_buf_get_option(bufnr, "buflisted") then
      return
    end
    local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
    if buftype ~= "" and buftype ~= "acwrite" then
      return
    end

    -- Check if LSP client supports inlay hints before disabling
    local clients = vim.lsp.get_active_clients({ buffer = bufnr })
    for _, client in pairs(clients) do
      if client.supports_method("textDocument/inlayHint") then
        vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
        return -- Disable once for the buffer if any client supports it
      end
    end
  end,
})
