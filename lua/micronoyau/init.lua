-- Leader key must be set before lazy.nvim loads plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("micronoyau.options")
require("micronoyau.lazy")    -- plugins + their config functions run here
require("micronoyau.keymaps") -- no plugin deps, safe to load after lazy
