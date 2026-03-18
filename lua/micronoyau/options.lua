local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smarttab = true
opt.autoindent = true
opt.smartindent = true

-- Display
opt.wrap = false
opt.sidescroll = 16
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.signcolumn = "yes:2"
opt.cursorline = true
opt.termguicolors = true
opt.showmode = false -- lualine shows the mode

-- Search
opt.hlsearch = false
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Completion
opt.completeopt = { "menu", "menuone", "noselect" }

-- Misc
opt.undofile = true
opt.updatetime = 250
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.confirm = true

-- Markdown preview
vim.g.mkdp_filetypes = { "markdown" }
