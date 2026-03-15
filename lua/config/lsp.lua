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

function M.setup()
  local capabilities = require("blink.cmp").get_lsp_capabilities()

  vim.diagnostic.config {
    severity_sort = true,
    underline = true,
    virtual_text = { source = "if_many", spacing = 2 },
    float = { border = "rounded", source = "if_many" },
  }

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
