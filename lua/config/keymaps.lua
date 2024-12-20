-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- 设置 <leader> 键为空格键
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 常用快捷键映射
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- 将 jj 映射为 Esc
map("i", "jk", "<Esc>", opts)

-- 保存文件
map("n", "<leader>w", ":w<CR>", opts)

-- 退出文件
map("n", "<leader>q", ":q<CR>", opts)

-- 保存并退出文件
map("n", "<leader>wq", ":wq<CR>", opts)

-- 关闭当前缓冲区
map("n", "<leader>c", ":bd<CR>", opts)

-- 打开文件浏览器
map("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- 打开文件搜索
map("n", "<leader>f", ":Telescope find_files<CR>", opts)

-- 打开字符串搜索
map("n", "<leader>s", ":Telescope live_grep<CR>", opts)

-- 打开文件搜索

