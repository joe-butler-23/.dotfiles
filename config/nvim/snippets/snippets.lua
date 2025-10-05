local ls = require("luasnip") -- Load LuaSnip
local s = ls.snippet -- Shortcut for snippet
local t = ls.text_node -- Shortcut for text nodes
local i = ls.insert_node -- Shortcut for insert nodes

-- Define snippets for R Markdown
ls.add_snippets("all", { -- Target the rmarkdown file type
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
