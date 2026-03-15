return {
  {
    "folke/snacks.nvim",
    keys = {
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
      lazygit = {},
      picker = {
        enabled = true,
        layout = {
          preset = "default",
        },
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
