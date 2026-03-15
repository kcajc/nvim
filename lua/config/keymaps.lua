local map = vim.keymap.set
local lsp = require("config.lsp")

map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

map("n", "<Leader>w", "<cmd>w<CR>", { desc = "Save" })
map("n", "<Leader>q", "<cmd>confirm q<CR>", { desc = "Quit" })
map("n", "<Leader>bd", "<cmd>bdelete<CR>", { desc = "Close" })
map("n", "<Leader>ud", lsp.toggle_diagnostics, { desc = "Diagnostics" })
map("n", "<Leader>uH", function()
  if not vim.lsp.inlay_hint then
    return
  end

  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Inlay all" })
map("n", "<Leader>uv", lsp.toggle_diagnostics_virtual_text, { desc = "Virtual text" })
map("n", "<Leader>t", function()
  vim.cmd.vsplit()
  vim.cmd.terminal()
  vim.cmd.startinsert()
end, { desc = "Term" })
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus left" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus down" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus up" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus right" })

map("n", "H", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "L", "<cmd>bnext<CR>", { desc = "Next buffer" })

map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
-- map("n", "<Leader>xx", vim.diagnostic.open_float, { desc = "Line" })
