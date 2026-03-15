return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    main = "nvim-treesitter.configs",
    opts = function()
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.spthy = {
        install_info = {
          url = "https://github.com/tamarin-prover/tamarin-prover",
          branch = "develop",
          location = "tree-sitter/tree-sitter-spthy",
          files = { "src/parser.c", "src/scanner.c" },
          generate_requires_npm = false,
          requires_generate_from_grammar = false,
        },
        filetype = "spthy",
      }

      return {
        ensure_installed = {
          "bash",
          "css",
          "html",
          "javascript",
          "jsdoc",
          "json",
          "latex",
          "lua",
          "luadoc",
          "markdown",
          "markdown_inline",
          "python",
          "query",
          "regex",
          "rust",
          "spthy",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true, disable = { "latex", "spthy" } },
        disable = function(_, buf)
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
          return ok and stats and stats.size > 100 * 1024
        end,
      }
    end,
  },
}
