return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    opts = {
      variant = "moon",
      dark_variant = "moon",
    },
    config = function(_, opts)
      require("rose-pine").setup(opts)
      vim.cmd.colorscheme("rose-pine")
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 900,
    opts = {},
    config = function(_, opts)
      require("tokyonight").setup(opts)
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 900,
    opts = {},
    config = function(_, opts)
      require("catppuccin").setup(opts)
    end,
  },
}
