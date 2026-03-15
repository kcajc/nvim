local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

map("n", "<Leader>w", "<cmd>w<CR>", { desc = "Save" })
map("n", "<Leader>q", "<cmd>confirm q<CR>", { desc = "Quit" })
map("n", "<Leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus left" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus down" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus up" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus right" })

map("n", "H", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "L", "<cmd>bnext<CR>", { desc = "Next buffer" })

map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<Leader>xx", vim.diagnostic.open_float, { desc = "Line diagnostics" })
