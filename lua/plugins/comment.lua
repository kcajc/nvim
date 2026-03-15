return {
  {
    "nvim-mini/mini.comment",
    version = "*",
    event = "VeryLazy",
    keys = {
      {
        "<Leader>/",
        function()
          local line = vim.fn.line(".")
          require("mini.comment").toggle_lines(line, line + vim.v.count1 - 1)
        end,
        desc = "Comment",
      },
    },
    opts = {},
    config = function(_, opts)
      require("mini.comment").setup(opts)
    end,
  },
}
