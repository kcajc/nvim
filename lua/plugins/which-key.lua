return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      icons = {
        group = "",
        mappings = false,
      },
      spec = {
        { "<leader>b", group = "Buffers" },
        { "<leader>c", group = "Code" },
        { "<leader>f", group = "Find" },
        { "<leader>l", group = "LSP" },
        { "<leader>r", group = "Rename" },
        { "<leader>u", group = "Toggle" },
        { "<leader>x", group = "Diag" },
      },
    },
  },
}
