return {
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.g.tex_flavor = "latex"
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = { continuous = 1 }
      -- Turn this on to forward search on save
      -- vim.g.vimtex_view_skim_sync = 1
      vim.g.vimtex_view_skim_reading_bar = 1
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_syntax_enabled = 0
      vim.g.vimtex_syntax_conceal_disable = 1
    end,
    config = function()
      vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("user-vimtex", { clear = true }),
        pattern = "VimtexEventInitPost",
        command = "silent! VimtexCompile!",
        desc = "Start VimTeX compiler on open",
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user-tex", { clear = true }),
        pattern = "tex",
        callback = function(args)
          vim.keymap.set("n", "<Leader>v", function() vim.cmd.VimtexView() end, {
            buffer = args.buf,
            desc = "PDF sync",
          })
        end,
      })
    end,
  },
}
