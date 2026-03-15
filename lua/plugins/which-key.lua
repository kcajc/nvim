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
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>l", group = "LSP" },
        { "<leader>r", group = "Rename" },
        { "<leader>u", group = "UI" },
      },
    },
  },
}
