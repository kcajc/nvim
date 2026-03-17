vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function() vim.hl.on_yank() end,
  desc = "Highlight yanked text",
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user-wrap", { clear = true }),
  pattern = { "gitcommit", "markdown", "plaintex", "tex", "text" },
  callback = function()
    vim.opt_local.wrap = true
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map("n", "gl", vim.diagnostic.open_float, "Line")
    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
    map("n", "gr", vim.lsp.buf.references, "Go to references")
    map("n", "gI", vim.lsp.buf.implementation, "Go to implementation")
    map("n", "K", vim.lsp.buf.hover, "Hover")
    map("n", "<Leader>li", "<cmd>LspInfo<CR>", "Info")
    map("n", "<Leader>ld", vim.diagnostic.open_float, "Line")
    map("n", "<Leader>lD", function() vim.diagnostic.setqflist { open = true } end, "Quickfix")
    map("n", "<Leader>la", vim.lsp.buf.code_action, "Action")
    map("n", "<Leader>lr", vim.lsp.buf.rename, "Rename")
    map("n", "<Leader>lR", vim.lsp.buf.references, "Refs")
    map("n", "<Leader>lf", function() vim.lsp.buf.format { async = true } end, "Format")

    -- if client and client:supports_method("textDocument/codeAction") then
    --   map("n", "<Leader>lA", function()
    --     vim.lsp.buf.code_action { context = { only = { "source" } } }
    --   end, "Source")
    -- end

    if client and client:supports_method("textDocument/signatureHelp") then
      map("n", "<Leader>lh", vim.lsp.buf.signature_help, "Signature")
    end

    if client and client:supports_method("textDocument/documentSymbol") then
      map("n", "<Leader>ls", vim.lsp.buf.document_symbol, "Symbols")
    end

    if client and client:supports_method("workspace/symbol") then
      map("n", "<Leader>lG", vim.lsp.buf.workspace_symbol, "Workspace")
    end

    if vim.lsp.inlay_hint and client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      map("n", "<Leader>uh", function()
        local filter = { bufnr = bufnr }
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(filter), filter)
      end, "Inlay")
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local group = vim.api.nvim_create_augroup("user-lsp-highlight-" .. bufnr, { clear = true })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd("LspDetach", {
        group = group,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = group, buffer = bufnr }
        end,
      })
    end
  end,
})
