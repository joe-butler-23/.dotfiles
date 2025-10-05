_G.Snacks = _G.Snacks or require("snacks")

-- Writing mode

local writing_mode_toggle = Snacks.toggle({
  name = "Writing Mode",
  get = function()
    return vim.b.writing_mode and true or false
  end,
  set = function(state)
    vim.b.writing_mode = state
    if state then
      vim.cmd("SoftPencil")
      vim.cmd("TwilightEnable")
      vim.cmd("ZenMode")
      vim.wo.spell = true
      vim.opt_local.scrolloff = 1000
    else
      vim.cmd("NoPencil")
      vim.cmd("TwilightDisable")
      vim.cmd("ZenMode")
      vim.wo.spell = false
      vim.opt_local.scrolloff = 0
    end
  end,
})

local function toggle_writing_mode()
  writing_mode_toggle:toggle()
  if vim.b.writing_mode then
    vim.notify("Writing Mode Enabled", vim.log.levels.INFO)
  else
    vim.notify("Writing Mode Disabled", vim.log.levels.INFO)
  end
end -- Added the missing 'end' here

vim.keymap.set({ "n" }, "<leader>tw", toggle_writing_mode, { desc = "Toggle Writing Mode" })

-- Autocompletion
opts = function(_, opts)
  local completion_toggle = Snacks.toggle({
    name = "Completion",
    get = function()
      return vim.b.completion == nil or vim.b.completion
    end,
    set = function(state)
      vim.b.completion = state
    end,
  })
  local function toggle_completion()
    require("blink.cmp").hide() -- Hides suggestions when disabling
    completion_toggle:toggle()

    if vim.b.completion then
      vim.notify("Autocomplete Enabled", vim.log.levels.INFO)
    else
      vim.notify("Autocomplete Disabled", vim.log.levels.WARN)
    end
  end

  -- 🔑 Map <leader>ta to toggle completion
  vim.keymap.set({ "n" }, "<leader>ta", toggle_completion, { desc = "Toggle Autocomplete" })

  -- Make completion respect the toggle state
  opts.enabled = function()
    return vim.b.completion
  end

  -- Ensure completion is enabled by default for new buffers
  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
      if vim.b.completion == nil then
        vim.b.completion = true
      end
    end,
  })

  -- Disable autocomplete in Telescope prompt buffers
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "TelescopePrompt",
    callback = function()
      vim.b.completion = false
    end,
  })
end

-- Ltex toggle

local ltex_toggle = Snacks.toggle({
  name = "LTeX",
  get = function()
    for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      if client.name == "ltex" then
        return true
      end
    end
    return false
  end,
  set = function(state)
    if state then
      -- More comprehensive server configuration
      vim.lsp.start({
        name = "ltex",
        cmd = { "ltex-ls" },
        filetypes = { "markdown", "latex", "tex" },
        root_dir = vim.fs.dirname(vim.api.nvim_buf_get_name(0)), -- Use current file's directory
        settings = {
          ltex = {
            language = "en-GB", -- Set your preferred language
            diagnosticSeverity = "information",
            additionalRules = {
              enablePickyRules = true,
              motherTongue = "en-GB",
            },
            rules = {
              enabled = {
                "WEASEL_WORDS", -- Avoid hype words like "clearly", "novel"
                "CLICHES", -- Catch clichés
                "VAGUE_WORDS", -- Words like "very", "really", etc.
                "REDUNDANT_PHRASES", -- "in order to", "by means of", etc.
                "WORDINESS", -- Long-winded phrases
                "COMPLEX_PHRASE", -- Prefer simpler alternatives
                "NEGATIONS", -- "not able" → "unable"
                "SIMPLIFY_EXPRESSION", -- Shorter, more direct language
                "PASSIVE_VOICE", -- Passive constructions
                "INFORMAL_WORDS", -- Social/casual phrasing
                "RARE_WORDS", -- Obscure or overly fancy terms
                "LATINISMS", -- Avoid Latinisms unless necessary
                "ABBREVIATIONS", -- Warn about excessive abbreviation use
                "NOMINALIZATION", -- Avoid zombie nouns
                "STYLE_NOMINALIZATION", -- Duplicate/related rule for nominalizationa
              },
            },
          },
        },
        -- Use the buffer's filetype to determine if the server should attach
        on_attach = function(client, bufnr)
          local ft = vim.bo[bufnr].filetype
          if not vim.tbl_contains({ "markdown", "latex", "tex" }, ft) then
            vim.lsp.buf_detach_client(bufnr, client.id)
            return
          end
          vim.notify("LTeX attached to buffer", vim.log.levels.INFO)
        end,
      })
      vim.notify("LTeX Started", vim.log.levels.INFO)
    else
      for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
        if client.name == "ltex" then
          vim.lsp.stop_client(client.id)
          vim.notify("LTeX Stopped", vim.log.levels.WARN)
        end
      end
    end
  end,
})

vim.keymap.set({ "n" }, "<leader>tl", function()
  ltex_toggle:toggle()
end, { desc = "Toggle LTeX Language Server" })

return opts
