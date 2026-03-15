local M = {}

M.servers = {
  "lua_ls",
  "pyright",
  "rust_analyzer",
  "ts_ls",
  "html",
  "cssls",
  "texlab",
}

M.diagnostic_virtual_text = { source = "if_many", spacing = 2 }

M.diagnostics = {
  severity_sort = true,
  underline = true,
  virtual_text = false,
  float = { border = "rounded", source = "if_many" },
}

function M.toggle_diagnostics()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end

function M.toggle_diagnostics_virtual_text()
  local diagnostics = vim.diagnostic.config()
  vim.diagnostic.config {
    virtual_text = diagnostics.virtual_text == false and M.diagnostic_virtual_text or false,
  }
end

function M.setup()
  local capabilities = require("blink.cmp").get_lsp_capabilities()

  vim.diagnostic.config(M.diagnostics)
  if vim.lsp.inlay_hint then
    vim.lsp.inlay_hint.enable(false)
  end

  for _, server in ipairs(M.servers) do
    vim.lsp.config(server, { capabilities = capabilities })
  end

  vim.lsp.config("lua_ls", {
    capabilities = capabilities,
    settings = {
      Lua = {
        completion = { callSnippet = "Replace" },
        diagnostics = { globals = { "vim" } },
        telemetry = { enable = false },
        workspace = { checkThirdParty = false },
      },
    },
  })

  vim.lsp.enable(M.servers)
end

return M
