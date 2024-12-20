-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- 设置行号
vim.opt.number = true

-- 设置相对行号
vim.opt.relativenumber = true

-- 设置缩进
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- 启用鼠标支持
vim.opt.mouse = 'a'

-- 启用语法高亮
vim.cmd('syntax on')

-- 设置颜色主题
vim.cmd('colorscheme desert')

-- 启用行尾标记
vim.opt.list = true
vim.opt.listchars = { tab = '▸ ', trail = '·' }

-- 启用自动换行
vim.opt.wrap = true

-- 设置搜索高亮
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- 禁用备份文件
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- 设置剪贴板
vim.opt.clipboard = 'unnamedplus'

-- 设置自动缩进
vim.opt.autoindent = true

-- 设置自动保存
vim.opt.autowrite = true


