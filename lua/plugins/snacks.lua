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
        "<Leader>gb",
        function() Snacks.picker.git_branches() end,
        desc = "Branches",
      },
      {
        "<Leader>gc",
        function() Snacks.picker.git_log() end,
        desc = "Commits",
      },
      {
        "<Leader>gC",
        function() Snacks.picker.git_log_file() end,
        desc = "Buffer commits",
      },
      {
        "<Leader>gh",
        function() Snacks.picker.git_diff({ group = false }) end,
        desc = "Hunks",
      },
      {
        "<Leader>gg",
        function() Snacks.lazygit() end,
        desc = "Lazygit",
      },
      {
        "<Leader>go",
        function() Snacks.gitbrowse() end,
        desc = "Open in browser",
        mode = { "n", "v" },
      },
      {
        "<Leader>gt",
        function() Snacks.picker.git_status() end,
        desc = "Status",
      },
      {
        "<Leader>gT",
        function() Snacks.picker.git_stash() end,
        desc = "Stash",
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
      gitbrowse = {},
      lazygit = {},
      picker = {
        enabled = true,
        layout = {
          preset = "default",
        },
        sources = {
          explorer = {
            layout = {
              hidden = { "input" },
            },
            formatters = {
              severity = { icons = false },
            },
          },
        },
        win = {
          input = {
            keys = {
              ["jj"] = { "focus_list", mode = "i" },
            },
          },
          list = {
            keys = {
              J = "preview_scroll_down",
              K = "preview_scroll_up",
            },
          },
          preview = {
            keys = {
              J = "preview_scroll_down",
              K = "preview_scroll_up",
            },
          },
        },
      },
    },
  },
}
