return {
  "rmagatti/auto-session",
  config = function()
    require("auto-session").setup({
      auto_session_suppress_dirs = { "~", "~/Projects", "~/Downloads", "/" },
      buftypes_to_ignore = {},
      auto_save = true,
      border = true,
      rename = false,
    })
    vim.keymap.set("n", "<Leader>fs", require("auto-session.session-lens").search_session, { noremap = true })
  end,
}
