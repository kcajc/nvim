return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      panel = { enabled = false },
      suggestion = {
        auto_trigger = true,
        debounce = 150,
        keymap = {
          accept = "<C-l>",
          dismiss = "<C-]>",
        },
      },
    },
    config = function(_, opts)
      require("copilot").setup(opts)

      local group = vim.api.nvim_create_augroup("copilot_blink_visibility", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "BlinkCmpMenuOpen",
        callback = function() vim.b.copilot_suggestion_hidden = true end,
      })
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "BlinkCmpMenuClose",
        callback = function() vim.b.copilot_suggestion_hidden = false end,
      })
    end,
  },
}
