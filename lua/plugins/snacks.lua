return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<Space>e",
        function() Snacks.explorer() end,
        desc = "Files",
      },
      {
        "<Leader>gg",
        function() Snacks.lazygit() end,
        desc = "Lazygit",
      },
      {
        "<Leader>ff",
        function() Snacks.picker.files() end,
        desc = "File",
      },
      {
        "<Leader>fw",
        function() Snacks.picker.grep() end,
        desc = "Word",
      },
      {
        "<Leader>ft",
        function() Snacks.picker.colorschemes() end,
        desc = "Theme",
      },
    },
    opts = {
      explorer = { enabled = true },
      lazygit = {},
      picker = {
        enabled = true,
        -- icons = {
        --   files = { enabled = false },
        --   git = { enabled = false },
        -- },
        layout = {
          preset = "default",
        },
        -- sources = {
        --   explorer = {
        --     formatters = {
        --       severity = { pos = false, icons = false, level = false },
        --     },
        --   },
        -- },
        win = {
          input = {
            keys = {
              ["jj"] = { "focus_list", mode = "i" },
            },
          },
        },
      },
    },
  },
}
