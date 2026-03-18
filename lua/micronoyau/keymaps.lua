local map = vim.keymap.set

-----------------------------------------------------------------
-- Window navigation
-----------------------------------------------------------------
map("n", "<C-j>", "<C-w>j", { desc = "Move to below window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to above window" })

-----------------------------------------------------------------
-- Window resizing
-----------------------------------------------------------------
map("n", "<leader>+", ":resize +10<CR>", { desc = "Increase height" })
map("n", "<leader>-", ":resize -10<CR>", { desc = "Decrease height" })
map("n", "<leader>>", ":vertical resize +10<CR>", { desc = "Increase width" })
map("n", "<leader><", ":vertical resize -10<CR>", { desc = "Decrease width" })
map("n", "<leader>=", "<C-w>=", { desc = "Equalize window sizes" })

-----------------------------------------------------------------
-- Splits
-----------------------------------------------------------------
map("n", "<leader>s", ":vs<CR>", { desc = "Vertical split" })
map("n", "<leader>S", ":sp<CR>", { desc = "Horizontal split" })
map("n", "<leader>fs", ":tab split<CR>", { desc = "Full-screen tab split" })

-----------------------------------------------------------------
-- Bufferline / Tab navigation
-----------------------------------------------------------------
map("n", "<leader>q", function()
    local cur = vim.api.nvim_get_current_buf()
    local real_bufs = vim.tbl_filter(function(b)
        return vim.bo[b].buflisted
            and vim.bo[b].filetype ~= "neo-tree"
            and b ~= cur
    end, vim.api.nvim_list_bufs())
    -- Switch the current window to another buffer before deleting so the
    -- window is never closed (which would leave only neo-tree and exit Neovim)
    if #real_bufs > 0 then
        vim.api.nvim_set_current_buf(real_bufs[#real_bufs])
    else
        vim.cmd("enew")
    end
    vim.cmd("bd " .. cur)
end, { desc = "Close buffer" })
map("n", "<C-l>", ":BufferLineCycleNext<CR>", { desc = "Go to right buffer" })
map("n", "<C-h>", ":BufferLineCyclePrev<CR>", { desc = "Go to left buffer" })
map("n", "<C-M-l>", ":BufferLineMoveNext<CR>", { desc = "Move buffer right" })
map("n", "<C-M-h>", ":BufferLineMovePrev<CR>", { desc = "Move buffer left" })
map("n", "<leader>bp", ":BufferLineTogglePin<CR>", { desc = "Pin buffer" })
map("n", "<leader>bx", ":BufferLineCloseOthers<CR>", { desc = "Close other buffers" })
map("n", "<leader>bl", ":Telescope buffers<CR>", { desc = "List open buffers" })
for i = 1, 9 do
    map("n", "<leader>b" .. i, function()
        require("bufferline").go_to(i, true)
    end, { desc = "Go to buffer " .. i })
end

-----------------------------------------------------------------
-- Oil (file explorer)
-----------------------------------------------------------------
map("n", "<leader>ef", ":Oil --float<CR>", { desc = "Open Oil (floating)" })

-----------------------------------------------------------------
-- Neo-tree (file tree)
-----------------------------------------------------------------
map("n", "<leader>ee", ":Neotree toggle<CR>", { desc = "Toggle file tree" })
map("n", "<leader>er", ":Neotree reveal<CR>", { desc = "Reveal file in tree" })

-----------------------------------------------------------------
-- Telescope
-----------------------------------------------------------------
map("n", "<leader>ff", ":Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>fb", ":Telescope live_grep grep_open_files=true<CR>", { desc = "Find in open buffers" })
map("n", "<leader>fa", ":Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>ft", ":TodoTelescope<CR>", { desc = "TODO comments" })
map("n", "<leader>fo", ":Telescope lsp_document_symbols<CR>", { desc = "Document symbols" })
map("n", "<leader>fc", ":Telescope current_buffer_fuzzy_find<CR>", { desc = "Fuzzy search buffer" })

-----------------------------------------------------------------
-- Clipboard
-----------------------------------------------------------------
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
map("n", "<leader>p", '"+p', { desc = "Paste from clipboard" })

-----------------------------------------------------------------
-- Tab width toggles
-----------------------------------------------------------------
map("n", "<leader>t2", function()
    vim.opt.shiftwidth = 2
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2
end, { desc = "Set indent to 2" })

map("n", "<leader>t4", function()
    vim.opt.shiftwidth = 4
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
end, { desc = "Set indent to 4" })

-----------------------------------------------------------------
-- Terminal (toggleterm)
-----------------------------------------------------------------
map("n", "<leader>tt", ":ToggleTerm direction=horizontal<CR>", { desc = "Toggle terminal" })
map("n", "<leader>tv", ":ToggleTerm direction=vertical size=80<CR>", { desc = "Toggle terminal (vertical)" })
map("n", "<leader>tf", ":ToggleTerm direction=float<CR>", { desc = "Toggle terminal (float)" })
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-----------------------------------------------------------------
-- Hex editor
-----------------------------------------------------------------
map("n", "<leader>hd", ":HexDump<CR>", { desc = "Hex dump" })
map("n", "<leader>ha", ":HexAssemble<CR>", { desc = "Hex assemble" })
map("n", "<leader>ht", ":HexToggle<CR>", { desc = "Hex toggle" })

-----------------------------------------------------------------
-- Markdown preview
-----------------------------------------------------------------
map("n", "<leader>mp", ":MarkdownPreview<CR>", { desc = "Markdown preview" })
map("n", "<leader>ms", ":MarkdownPreviewStop<CR>", { desc = "Markdown preview stop" })

-----------------------------------------------------------------
-- Git (fugitive + gitsigns + flog)
-----------------------------------------------------------------
map("n", "<leader>gp", ":Gitsigns preview_hunk_inline<CR>", { desc = "Preview hunk" })
map("n", "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle line blame" })
map("n", "<leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
map("n", "<leader>gR", ":Gitsigns reset_buffer<CR>", { desc = "Reset buffer" })
map("n", "<leader>gn", ":Gitsigns next_hunk<CR>", { desc = "Next hunk" })
map("n", "<leader>gN", ":Gitsigns prev_hunk<CR>", { desc = "Previous hunk" })
map("n", "<leader>gb", ":Git blame<CR>", { desc = "Git blame" })
map("n", "<leader>ga", ":Git add %<CR>", { desc = "Git add current file" })
map("n", "<leader>gs", ":Git status<CR>", { desc = "Git status" })
map("n", "<leader>gc", ":Git commit<CR>", { desc = "Git commit" })
map("n", "<leader>gl", ":Flogsplit<CR>", { desc = "Git log graph" })
map("n", "<leader>gd", ":DiffviewOpen<CR>", { desc = "Git diff (side-by-side)" })
map("n", "<leader>gD", ":DiffviewFileHistory %<CR>", { desc = "Git file history" })
map("n", "<leader>gx", function()
    -- Clear the modified flag on diffview's nowrite buffers before closing
    -- to avoid the "Other window contains changes" tabclose error.
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].modified and vim.bo[buf].buftype == "nowrite" then
            vim.bo[buf].modified = false
        end
    end
    vim.cmd("DiffviewClose")
end, { desc = "Close diffview" })

-----------------------------------------------------------------
-- Minimap
-----------------------------------------------------------------
map("n", "<leader>mm", "<cmd>Neominimap Toggle<CR>", { desc = "Toggle minimap" })
map("n", "<leader>mf", "<cmd>Neominimap Focus<CR>", { desc = "Focus minimap" })
map("n", "<leader>mu", "<cmd>Neominimap Unfocus<CR>", { desc = "Unfocus minimap" })

-----------------------------------------------------------------
-- LSP keymaps: check out lazy.lua
-----------------------------------------------------------------

-----------------------------------------------------------------
-- Misc convenience
-----------------------------------------------------------------
-- Clear search highlight on Esc (since hlsearch is off by
-- default, this is a safety net if you :set hlsearch)
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Move selected lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered during search navigation
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })
