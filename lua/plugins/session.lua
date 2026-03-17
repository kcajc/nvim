return {
  {
    "folke/persistence.nvim",
    lazy = false,
    keys = {
      {
        "<Leader>ss",
        function() require("persistence").load() end,
        desc = "Restore session",
      },
      {
        "<Leader>sS",
        function() require("persistence").select() end,
        desc = "Select session",
      },
      -- {
      --   "<Leader>sl",
      --   function() require("persistence").load({ last = true }) end,
      --   desc = "Restore last",
      -- },
      {
        "<Leader>sd",
        function() require("persistence").stop() end,
        desc = "Stop sessions",
      },
    },
    opts = {
      branch = false,
    },
    config = function(_, opts)
      local persistence = require("persistence")
      persistence.setup(opts)

      local group = vim.api.nvim_create_augroup("user-session-startup", { clear = true })

      vim.api.nvim_create_autocmd("StdinReadPre", {
        group = group,
        callback = function() vim.g.started_with_stdin = true end,
      })

      vim.api.nvim_create_autocmd("VimEnter", {
        group = group,
        callback = function()
          if vim.g.started_with_stdin then
            return
          end

          local argc = vim.fn.argc()
          if argc == 0 then
            persistence.load()
            return
          end

          if argc ~= 1 then
            return
          end

          local arg = vim.fn.argv(0)
          if vim.fn.isdirectory(arg) ~= 1 then
            return
          end

          vim.cmd.cd(vim.fn.fnamemodify(arg, ":p"))
          persistence.load()
        end,
      })
    end,
  },
}
