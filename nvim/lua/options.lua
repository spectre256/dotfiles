local opt = vim.opt

-- better indentation
opt.autoindent = true

-- UI settings
opt.cursorline = true
opt.syntax = 'on'
opt.number = true
opt.relativenumber = true
opt.laststatus = 3
opt.showmode = false

-- tab settings
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

-- padding
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false

-- search options
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- menu options
opt.pumheight = 12

-- Python integration
vim.g.python3_host_prog = 'usr/bin/python3'
vim.g.python2_host_prog = 'usr/bin/python2'
