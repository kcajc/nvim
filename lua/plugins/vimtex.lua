return {
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.g.tex_flavor = "latex"
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_compiler_method = "latexmk"

      if vim.fn.executable("sioyek") == 1 then
        vim.g.vimtex_view_method = "sioyek"
      elseif vim.fn.executable("zathura") == 1 then
        vim.g.vimtex_view_method = "zathura"
      elseif vim.fn.has("mac") == 1 and vim.fn.isdirectory("/Applications/Skim.app") == 1 then
        vim.g.vimtex_view_method = "skim"
      end
    end,
  },
}
