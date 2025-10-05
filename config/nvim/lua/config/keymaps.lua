-- Normal mode: Yank the current line to the system clipboard.
vim.keymap.set("n", "<C-S-c>", '"+y', { noremap = true, silent = true })

-- Visual mode: Yank the selected text to the system clipboard.
vim.keymap.set("v", "<C-S-c>", '"+y', { noremap = true, silent = true })

-- Insert mode: Yank the selected text to the system clipboard.
vim.keymap.set("i", "<C-S-c>", '"+y', { noremap = true, silent = true })

-- Select all
vim.keymap.set("n", "<C-a>", "ggVG", { noremap = true, silent = true })
vim.keymap.set("i", "<C-a>", "ggVG", { noremap = true, silent = true })
