return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        "<Leader>gp",
        function() require("gitsigns").preview_hunk() end,
        desc = "Preview hunk",
      },
      {
        "<Leader>gr",
        function()
          local start = vim.fn.line(".")
          local finish = vim.fn.line("v")
          require("gitsigns").reset_hunk({ math.min(start, finish), math.max(start, finish) })
        end,
        mode = "x",
        desc = "Reset selection",
      },
      {
        "<Leader>gr",
        function() require("gitsigns").reset_hunk() end,
        desc = "Reset hunk",
      },
      {
        "<Leader>gR",
        function() require("gitsigns").reset_buffer() end,
        desc = "Reset buffer",
      },
      {
        "<Leader>gd",
        function() require("gitsigns").diffthis() end,
        desc = "Diff this",
      },
    },
    opts = {
      signcolumn = true,
      numhl = false,
      linehl = false,
      current_line_blame = false,
    },
  },
}
