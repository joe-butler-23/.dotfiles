return {
  "L3MON4D3/LuaSnip",
  enabled = true,
  config = function()
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node

    -- Define snippet for R Markdown
    ls.add_snippets("all", {
      s("rb", {
        t("```{r}"), -- Opening code block for R
        t({ "", "" }), -- Newline
        i(1, "code"), -- Placeholder for the code
        t({ "", "```" }), -- Closing code block
      }),
    })

    ls.add_snippets("tex", {
      s("cc", {
        t("\\cite{"),
        i(1, "key"), -- the default placeholder is "key", change as needed
        t("}"),
      }),
    })

    -- Set up keymaps for snippet navigation that work regardless of completion state
    vim.keymap.set({ "i", "s" }, "<Tab>", function()
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      else
        -- Pass through Tab normally if no snippet is active
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
      end
    end, { silent = true })

    vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
      if ls.jumpable(-1) then
        ls.jump(-1)
      else
        -- Pass through Shift-Tab normally if no snippet is active
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true), "n", false)
      end
    end, { silent = true })
  end,
}
