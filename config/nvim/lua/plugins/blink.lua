return {
  "saghen/blink.cmp",
  version = "*",
  dependencies = {
    {
      "micangl/cmp-vimtex",
      dependencies = {
        {
          "saghen/blink.compat",
          version = "*",
          lazy = true,
          opts = {},
        },
      },
    },
    -- Add LuaSnip as a dependency but without configuration (it will be configured in its own file)
    "L3MON4D3/LuaSnip",
  },
  opts = function(_, opts)
    -- Existing Configurations
    opts.snippets = {
      preset = "luasnip",

      expand = function(snippet)
        require("luasnip").lsp_expand(snippet)
      end,

      -- Check if a snippet is active or jumpable
      active = function(filter)
        if filter and filter.direction then
          return require("luasnip").jumpable(filter.direction)
        end
        return require("luasnip").in_snippet()
      end,

      -- Jump within snippet placeholders
      jump = function(direction)
        require("luasnip").jump(direction)
      end,
    }

    opts.appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    }

    opts.keymap = { preset = "super-tab" }

    opts.completion.ghost_text = { enabled = false }

    opts.sources = {
      default = {
        "vimtex",
        "lsp",
        "path",
        -- "snippets",
        -- "buffer",
        "cmp_luasnip",
        -- "avante_commands",
        -- "avante_mentions",
        -- "avante_files",
      },
      providers = {
        vimtex = {
          name = "vimtex",
          module = "blink.compat.source",
          score_offset = 101,
        },
        cmp_luasnip = {
          name = "cmp_luasnip",
          module = "blink.compat.source",
          score_offset = 101,
        },
        avante_commands = {
          name = "avante_commands",
          module = "blink.compat.source",
          score_offset = 101,
        },
        avante_mentions = {
          name = "avante_mentions",
          module = "blink.compat.source",
          score_offset = 101,
        },
        avante_files = {
          name = "avante_files",
          module = "blink.compat.source",
          score_offset = 101,
        },
      },
    }
  end,
}
