vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function() vim.hl.on_yank() end,
  desc = "Highlight yanked text",
})

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

local function is_placeholder_buffer(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return false
  end

  if vim.bo[buf].buftype ~= "" or vim.bo[buf].modified then
    return false
  end

  local name = vim.api.nvim_buf_get_name(buf)
  if name ~= "" then
    return vim.fn.isdirectory(name) == 1
  end

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  return #lines == 1 and lines[1] == ""
end

local function has_persistence_session()
  local persistence = require("persistence")
  local files = {
    persistence.current(),
    persistence.current({ branch = false }),
  }

  for _, file in ipairs(files) do
    if type(file) == "string" and vim.fn.filereadable(file) == 1 then
      return true
    end
  end

  return false
end

local startup_group = vim.api.nvim_create_augroup("user-startup", { clear = true })

vim.api.nvim_create_autocmd("StdinReadPre", {
  group = startup_group,
  callback = function() vim.g.started_with_stdin = true end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  group = startup_group,
  callback = function()
    if vim.g.started_with_stdin then
      return
    end

    local argc = vim.fn.argc()
    local target_dir
    local startup_buf = vim.api.nvim_get_current_buf()

    if argc == 0 then
      local lines = vim.api.nvim_buf_get_lines(startup_buf, 0, -1, false)
      local is_empty = #lines == 1 and lines[1] == ""

      if vim.bo[startup_buf].buftype ~= "" or vim.bo[startup_buf].modified or vim.api.nvim_buf_get_name(startup_buf) ~= "" or not is_empty then
        return
      end

      target_dir = vim.uv.cwd()
    elseif argc == 1 then
      local arg = vim.fn.argv(0)
      if vim.fn.isdirectory(arg) == 1 then
        target_dir = vim.fn.fnamemodify(arg, ":p")
        vim.cmd.cd(target_dir)
      end
    end

    if not target_dir then
      return
    end

    vim.schedule(function()
      if has_persistence_session() then
        require("persistence").load()

        if is_placeholder_buffer(startup_buf) and vim.api.nvim_get_current_buf() ~= startup_buf and #vim.fn.win_findbuf(startup_buf) == 0 then
          pcall(vim.api.nvim_buf_delete, startup_buf, { force = true })
        end

        return
      end

      require("lazy").load({ plugins = { "snacks.nvim" } })
      Snacks.explorer({ cwd = target_dir })

      if not vim.api.nvim_buf_is_valid(startup_buf) or vim.api.nvim_get_current_buf() == startup_buf then
        return
      end

      if is_placeholder_buffer(startup_buf) then
        pcall(vim.api.nvim_buf_delete, startup_buf, { force = true })
      end
    end)
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

    if client and client:supports_method("textDocument/codeAction") then
      map("n", "<Leader>lA", function()
        vim.lsp.buf.code_action { context = { only = { "source" } } }
      end, "Source")
    end

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
