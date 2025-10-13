return {
  -- Put border on K (keyword/lsp-definition) popup window
  {
    "blink.cmp",
    opts = {
      sources = {
        default = { "lsp", "path" },
      },
      selection = {
        preselect = false,
      },
      keymap = {
        preset = "default",
        ["<Tab>"] = { "accept", "fallback" },
        --["<Tab>"] = { "select_and_accept" },
      },
    },
  },
}
