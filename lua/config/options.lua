-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.modeline = true
vim.opt.modelines = 5

vim.opt.relativenumber = true
vim.opt.number = true

vim.opt.tabstop = 2 -- Length of a tab character in spaces.
vim.opt.softtabstop = 2 -- Length of a tab entered in insert mode
vim.opt.shiftwidth = 2 -- Length of an autoindent
vim.opt.expandtab = true -- Insert spaces instead of tab characters
vim.opt.autoindent = true -- Maintain indent from previous line

vim.g.mapleader = ","

vim.g.autoformat = false -- disable autoformat

-- Show search results by default, but hide them with ,<space>
vim.opt.hlsearch = true
vim.api.nvim_set_keymap("n", "<leader><space>", ":nohlsearch<CR>:match<CR>", { noremap = true })

-- Escape insert mode in terminal with ESC
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

-- Highlight word under cursor without moving to next match
vim.api.nvim_set_keymap(
  "n",
  "<leader>#",
  [[:<C-u>let @/ = expand('<cword>')<CR>:<C-u>set hlsearch<CR>]],
  { noremap = true }
)

-- Repeat last macro
vim.api.nvim_set_keymap("n", "<leader>,", "@@", { noremap = true })

-- Semi-pgup/down
vim.api.nvim_set_keymap("n", "<S-PageUp>", "10k", { noremap = true })
vim.api.nvim_set_keymap("n", "<S-PageDown>", "10j", { noremap = true })
