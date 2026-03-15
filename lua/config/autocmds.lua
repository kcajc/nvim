vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function() vim.hl.on_yank() end,
  desc = "Highlight yanked text",
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map("n", "gd", vim.lsp.buf.definition, "Goto definition")
    map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
    map("n", "gr", vim.lsp.buf.references, "Goto references")
    map("n", "gI", vim.lsp.buf.implementation, "Goto implementation")
    map("n", "K", vim.lsp.buf.hover, "Hover")
    map("n", "<Leader>rn", vim.lsp.buf.rename, "Rename")
    map({ "n", "x" }, "<Leader>ca", vim.lsp.buf.code_action, "Code action")
    map("n", "<Leader>lf", function() vim.lsp.buf.format { async = true } end, "Format buffer")

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
