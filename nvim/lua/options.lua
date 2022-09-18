local opt = vim.opt
local g = vim.g

-- better indentation
opt.autoindent = true

-- UI settings
opt.cursorline = true
opt.syntax = "on"
opt.number = true
opt.relativenumber = true
opt.laststatus = 3
opt.showmode = false
opt.termguicolors = true
g.catppuccin_flavour = "macchiato"
opt.list = true
opt.listchars = { tab = " ", trail = "⋅" } -- eol = "﬋"

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
g.python3_host_prog = "/usr/bin/python3"
g.python2_host_prog = "/usr/bin/python2"

-- use filetype.lua instead of filetype.vim
g.do_filetype_lua = 1
g.did_load_filetypes = 0

-- disable legacy neo-tree commands
g.neo_tree_remove_legacy_commands = 1
