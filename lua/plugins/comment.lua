return {
  {
    "nvim-mini/mini.comment",
    version = "*",
    event = "VeryLazy",
    keys = {
      {
        "<Leader>/",
        mode = { "n", "x" },
        desc = "Comment",
      },
    },
    opts = {
      mappings = {
        comment = "",
        comment_line = "<Leader>/",
        comment_visual = "<Leader>/",
      },
    },
    config = function(_, opts)
      require("mini.comment").setup(opts)
    end,
  },
}
