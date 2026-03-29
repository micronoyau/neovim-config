local map = vim.keymap.set

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
    if vim.bo.buftype ~= "" or not vim.bo.buflisted then
        return -- Ignore special buffers (NeoTree, quickfix, etc.)
    end
    local bufs = vim.fn.getbufinfo({ buflisted = 1 })
    if #bufs > 1 then
        vim.cmd("bp | bd#") -- Multiple buffers: go to previous (bp) and delete it (alternate buf #)
    else
        vim.cmd("bd")       -- Single buffer: delete it
    end
end, { desc = "Close buffer" })
map("n", "<C-l>", ":BufferLineCycleNext<CR>", { desc = "Go to right buffer" })
map("n", "<C-h>", ":BufferLineCyclePrev<CR>", { desc = "Go to left buffer" })
map("n", "<C-M-l>", ":BufferLineMoveNext<CR>", { desc = "Move buffer right" })
map("n", "<C-M-h>", ":BufferLineMovePrev<CR>", { desc = "Move buffer left" })
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
-- LSP
-----------------------------------------------------------------
map("n", "<leader>ll", function() vim.lsp.buf.hover({ border = "rounded" }) end, { desc = "Hover" })
map("n", "<leader>lf", function() vim.diagnostic.open_float({ border = "rounded" }) end, { desc = "Diagnostic float" })
map("n", "<leader>ln", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })
map("n", "<leader>lN", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Previous diagnostic" })
map("n", "<leader>ld", "<cmd>Telescope lsp_definitions<CR>", { desc = "Go to definition" })
map("n", "<leader>lt", "<cmd>Telescope lsp_type_definitions<CR>", { desc = "Type definition" })
map("n", "<leader>lx", "<cmd>Telescope lsp_references<CR>", { desc = "References" })
map("n", "<leader>li", function()
    -- Resolve the call hierarchy item at the cursor first, then fetch callers.
    -- Jump directly when there is exactly one result; open Telescope otherwise.
    local client = vim.lsp.get_clients({ bufnr = 0 })[1]
    local pos_params = vim.lsp.util.make_position_params(0, client.offset_encoding)
    vim.lsp.buf_request(0, "textDocument/prepareCallHierarchy", pos_params, function(err, items)
        if err or not items or #items == 0 then return end
        vim.lsp.buf_request(0, "callHierarchy/incomingCalls", { item = items[1] }, function(err2, calls)
            if err2 or not calls or #calls == 0 then
                vim.notify("No incoming calls found", vim.log.levels.INFO)
                return
            end
            if #calls == 1 then
                local from = calls[1].from
                vim.lsp.util.show_document(
                    { uri = from.uri, range = calls[1].fromRanges[1] },
                    client.offset_encoding,
                    { focus = true }
                )
            else
                require("telescope.builtin").lsp_incoming_calls()
            end
        end)
    end)
end, { desc = "Incoming calls" })
map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>=", function() require("conform").format({ async = true, lsp_fallback = true }) end,
    { desc = "Format buffer" })
map("n", "<leader>lDh", vim.diagnostic.hide, { desc = "Hide diagnostics" })
map("n", "<leader>lDs", vim.diagnostic.show, { desc = "Show diagnostics" })
map("n", "<leader>lsa", "<cmd>LspStart<CR>", { desc = "Start LSP" })
map("n", "<leader>lso", "<cmd>LspStop<CR>", { desc = "Stop LSP" })
map("n", "<leader>lss", "<cmd>LspInfo<CR>", { desc = "Show LSP status" })
map("n", "<leader>lm", "<cmd>Mason<CR>", { desc = "Manage LSPs" })

-----------------------------------------------------------------
-- Fuzzy finders
-----------------------------------------------------------------
map("n", "<leader>ff", ":Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>fb", ":Telescope live_grep grep_open_files=true<CR>", { desc = "Find in open buffers" })
map("n", "<leader>fa", ":Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>ft", ":TodoTelescope<CR>", { desc = "TODO comments" })
map("n", "<leader>fo", ":Telescope lsp_document_symbols<CR>", { desc = "Document symbols" })
map("n", "<leader>fc", ":Telescope current_buffer_fuzzy_find<CR>", { desc = "Fuzzy search buffer" })

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
-- Merge conflict resolution: check out diffview keymaps, defined in lazy.lua opts
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

-----------------------------------------------------------------
-- Noice
-----------------------------------------------------------------
map("n", "<leader>nn", "<cmd>Noice<CR>", { desc = "Noice message history" })
map("n", "<leader>na", "<cmd>NoiceAll<CR>", { desc = "Noice message history (verbose)" })

-----------------------------------------------------------------
-- Misc convenience
-----------------------------------------------------------------
-- Clear search highlight on Esc (since hlsearch is off by
-- default, this is a safety net if you :set hlsearch)
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Move selected lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
