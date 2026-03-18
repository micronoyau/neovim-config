-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

    -----------------------------------------------------------------
    -- Theme
    -----------------------------------------------------------------
    {
        "Mofiqul/vscode.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("vscode").setup({
                transparent = false,
                italic_comments = true,
                disable_nvimtree_bg = true,
                style = "dark", -- default; toggled via <leader>tt
            })
            vim.cmd([[colorscheme vscode]])

            -- Toggle between dark and light variants
            vim.keymap.set("n", "<leader>th", function()
                local current      = vim.g.vscode_style or "dark"
                local next         = current == "dark" and "light" or "dark"
                vim.g.vscode_style = next
                require("vscode").setup({
                    transparent         = false,
                    italic_comments     = true,
                    disable_nvimtree_bg = true,
                    style               = next,
                })
                vim.cmd([[colorscheme vscode]])
            end, { desc = "Toggle dark/light theme" })
        end,
    },

    -----------------------------------------------------------------
    -- UI: statusline
    -----------------------------------------------------------------
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "vscode",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { { "filename", path = 1 } },
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },

    -----------------------------------------------------------------
    -- UI: buffer tabs
    -----------------------------------------------------------------
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("bufferline").setup({
                options = {
                    mode = "buffers",
                    numbers = "ordinal",
                    close_command = "bdelete! %d",
                    right_mouse_command = "bdelete! %d",
                    diagnostics = "nvim_lsp",
                    diagnostics_indicator = function(count, level)
                        local icon = level:match("error") and " " or " "
                        return " " .. icon .. count
                    end,
                    show_buffer_icons = true,
                    show_buffer_close_icons = true,
                    show_close_icon = false,
                    separator_style = "slant",
                    always_show_bufferline = true,
                    offsets = {
                        {
                            filetype = "oil",
                            text = "File Explorer",
                            highlight = "Directory",
                            separator = true,
                        },
                    },
                },
            })
        end,
    },

    -----------------------------------------------------------------
    -- UI: keybinding hints
    -----------------------------------------------------------------
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {},
    },

    { "nvim-tree/nvim-web-devicons", lazy = true },

    -----------------------------------------------------------------
    -- File explorer (oil.nvim)
    -----------------------------------------------------------------
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("oil").setup({
                view_options = {
                    show_hidden = true,
                },
                columns = { "icon", "permissions", "size", "mtime" },
                delete_to_trash = true,
                keymaps = {
                    ["g?"]    = "actions.show_help",
                    ["<CR>"]  = "actions.select",
                    ["<C-v>"] = "actions.select_vsplit",
                    ["<C-s>"] = "actions.select_split",
                    ["<C-p>"] = "actions.preview",
                    ["<C-c>"] = "actions.close",
                    ["<C-r>"] = "actions.refresh",
                    ["-"]     = "actions.parent",
                    ["_"]     = "actions.open_cwd",
                    ["gs"]    = "actions.change_sort",
                    ["g."]    = "actions.toggle_hidden",
                    ["g\\"]   = "actions.toggle_trash",
                },
                default_file_explorer = true,
                float = {
                    padding = 2,
                    max_width = 120,
                    max_height = 40,
                    border = "rounded",
                },
            })
        end,
    },

    -----------------------------------------------------------------
    -- File tree (neo-tree)
    -----------------------------------------------------------------
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch       = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        cmd          = "Neotree",
        event        = "VimEnter",
        config       = function()
            require("neo-tree").setup({
                close_if_last_window      = true,
                popup_border_style        = "rounded",
                enable_git_status         = true,
                enable_diagnostics        = true,
                filesystem                = {
                    filtered_items         = {
                        visible         = false,
                        hide_dotfiles   = false,
                        hide_gitignored = true,
                    },
                    follow_current_file    = { enabled = true, leave_dirs_open = true },
                    use_libuv_file_watcher = true,
                },
                window                    = {
                    position = "left",
                    width    = 35,
                    mappings = {
                        ["<CR>"] = "open",
                        ["s"]    = "open_vsplit",
                        ["S"]    = "open_split",
                        ["z"]    = "close_all_nodes",
                        ["Z"]    = "expand_all_nodes",
                        ["R"]    = "refresh",
                        ["?"]    = "show_help",
                    },
                },
                default_component_configs = {
                    git_status = {
                        symbols = {
                            added     = " ",
                            modified  = " ",
                            deleted   = " ",
                            renamed   = "󰁕 ",
                            untracked = " ",
                            ignored   = " ",
                            unstaged  = "󰄱 ",
                            staged    = " ",
                            conflict  = " ",
                        },
                    },
                },
            })
            -- Open the tree on startup without stealing focus
            vim.cmd("Neotree show")
        end,
    },

    -----------------------------------------------------------------
    -- Fuzzy finder
    -----------------------------------------------------------------
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        config = function()
            local telescope = require("telescope")
            local actions   = require("telescope.actions")
            telescope.setup({
                defaults = {
                    path_display = { "truncate" },
                    sorting_strategy = "ascending",
                    layout_config = {
                        horizontal = {
                            prompt_position = "top",
                            preview_width = 0.55,
                        },
                        width = 0.87,
                        height = 0.80,
                    },
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                        },
                        n = {
                            ["<Esc>"] = actions.close,
                            ["q"]     = actions.close,
                        },
                    },
                },
                pickers = {
                    find_files = {
                        hidden = true,
                        find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
                    },
                    live_grep = {
                        additional_args = function()
                            return { "--hidden", "--glob", "!**/.git/*" }
                        end,
                    },
                },
            })
            pcall(telescope.load_extension, "fzf")
        end,
    },

    -----------------------------------------------------------------
    -- Treesitter (pinned to master — stable, pre-compiled parsers)
    -----------------------------------------------------------------
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash", "c", "cpp", "css", "dockerfile", "go",
                    "html", "java", "javascript", "json", "lua",
                    "markdown", "markdown_inline", "python", "rust",
                    "toml", "tsx", "typescript", "vim", "vimdoc", "yaml",
                },
                sync_install = false,
                auto_install = true,
                ignore_install = {},
                modules = {},
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection    = "<C-space>",
                        node_incremental  = "<C-space>",
                        scope_incremental = false,
                        node_decremental  = "<bs>",
                    },
                },
            })
        end,
    },

    { "neovim/nvim-lspconfig" },

    -- Mason + mason-lspconfig: install and auto-enable LSP servers
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ui = {
                    border = "rounded",
                    icons = {
                        package_installed   = "✓",
                        package_pending     = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        config = function()
            -------------------------------------------------------
            -- Per-server config via vim.lsp.config (Neovim 0.11 API)
            -------------------------------------------------------
            vim.lsp.config("clangd", {
                cmd = { "clangd", "--fallback-style=webkit" },
            })

            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        runtime     = { version = "LuaJIT" },
                        diagnostics = { globals = { "vim" } },
                        workspace   = {
                            library         = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry   = { enable = false },
                    },
                },
            })

            -- mason-lspconfig auto-enables all installed servers by default
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "bashls",
                    "clangd",
                    "docker_compose_language_service",
                    "dockerls",
                    "html",
                    "jdtls",
                    "jsonls",
                    "lemminx",
                    "lua_ls",
                    "marksman",
                    -- "pylsp",
                    "pyright",
                    "rust_analyzer",
                },
            })

            -------------------------------------------------------
            -- LSP keymaps via LspAttach autocommand (0.11 API)
            -------------------------------------------------------
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("micronoyau_lsp_keymaps", { clear = true }),
                callback = function(event)
                    local map = function(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
                    end

                    map("n", "<leader>ll", function()
                        vim.lsp.buf.hover(); vim.lsp.buf.hover()
                    end, "Hover")
                    map("n", "<leader>lf", function()
                        vim.diagnostic.open_float(); vim.diagnostic.open_float()
                    end, "Diagnostic float")
                    map("n", "<leader>ln", function()
                        vim.diagnostic.jump({ count = 1, float = true })
                    end, "Next diagnostic")
                    map("n", "<leader>lN", function()
                        vim.diagnostic.jump({ count = -1, float = true })
                    end, "Previous diagnostic")
                    map("n", "<leader>ld", vim.lsp.buf.definition, "Go to definition")
                    -- map("n", "<leader>lD",  vim.lsp.buf.declaration,        "Go to declaration")
                    map("n", "<leader>lt", vim.lsp.buf.type_definition, "Type definition")
                    map("n", "<leader>lx", vim.lsp.buf.references, "References")
                    map("n", "<leader>li", vim.lsp.buf.incoming_calls, "Incoming calls")
                    map("n", "<leader>lo", vim.lsp.buf.outgoing_calls, "Outgoing calls")
                    map("n", "<leader>lr", vim.lsp.buf.rename, "Rename symbol")
                    map("n", "<leader>la", vim.lsp.buf.code_action, "Code action")
                    map("n", "<leader>=", function()
                        require("conform").format({ async = true, lsp_fallback = true })
                    end, "Format buffer")
                    map("n", "<leader>lDh", vim.diagnostic.hide, "Hide diagnostics")
                    map("n", "<leader>lDs", vim.diagnostic.show, "Show diagnostics")
                    map("n", "<leader>lsa", "<cmd>LspStart<CR>", "Start LSP")
                    map("n", "<leader>lso", "<cmd>LspStop<CR>", "Stop LSP")
                    map("n", "<leader>lss", "<cmd>LspInfo<CR>", "Show LSP status")
                    map("n", "<leader>lm", "<cmd>Mason<CR>", "Manage LSPs")

                    -- Highlight references to the symbol under the cursor
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.supports_method("textDocument/documentHighlight") then
                        local hl_group = vim.api.nvim_create_augroup("micronoyau_lsp_highlight", { clear = false })
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer   = event.buf,
                            group    = hl_group,
                            callback = vim.lsp.buf.document_highlight,
                        })
                        vim.api.nvim_create_autocmd("CursorMoved", {
                            buffer   = event.buf,
                            group    = hl_group,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end
                end,
            })

            -------------------------------------------------------
            -- Diagnostic appearance
            -------------------------------------------------------
            vim.diagnostic.config({
                virtual_text     = { prefix = "●", spacing = 4 },
                signs            = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = " ",
                        [vim.diagnostic.severity.WARN]  = " ",
                        [vim.diagnostic.severity.HINT]  = "󰌵 ",
                        [vim.diagnostic.severity.INFO]  = " ",
                    },
                },
                underline        = true,
                update_in_insert = false,
                severity_sort    = true,
                float            = { border = "rounded", source = true },
            })

            -------------------------------------------------------
            -- Close floating diagnostic windows with <Esc>
            -------------------------------------------------------
            vim.api.nvim_create_autocmd("WinEnter", {
                group = vim.api.nvim_create_augroup("micronoyau_float_close", { clear = true }),
                callback = function()
                    local win = vim.api.nvim_get_current_win()
                    if vim.api.nvim_win_get_config(win).relative ~= "" then
                        vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", {
                            buffer = vim.api.nvim_win_get_buf(win),
                            silent = true,
                            nowait = true,
                            desc   = "Close floating window",
                        })
                    end
                end,
            })
        end,
    },

    -----------------------------------------------------------------
    -- Completion
    -----------------------------------------------------------------
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
            "onsails/lspkind.nvim",
        },
        config = function()
            local cmp     = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                window = {
                    completion    = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                formatting = {
                    format = lspkind.cmp_format({
                        mode          = "symbol_text",
                        maxwidth      = 50,
                        ellipsis_char = "...",
                    }),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-k>"]     = cmp.mapping.select_prev_item(),
                    ["<C-j>"]     = cmp.mapping.select_next_item(),
                    ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"]     = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"]     = cmp.mapping.abort(),
                    ["<CR>"]      = cmp.mapping.confirm({ select = false }),
                    ["<Tab>"]     = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"]   = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                }, {
                    { name = "buffer", keyword_length = 3 },
                }),
            })

            -- Extend LSP capabilities to advertise completion support
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            vim.lsp.config("*", { capabilities = capabilities })
        end,
    },

    -----------------------------------------------------------------
    -- Formatting
    -----------------------------------------------------------------
    {
        "stevearc/conform.nvim",
        event  = { "BufWritePre" },
        cmd    = { "ConformInfo" },
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    lua        = { "stylua" },
                    python     = { "black" },
                    javascript = { "prettier" },
                    typescript = { "prettier" },
                    json       = { "prettier" },
                    html       = { "prettier" },
                    css        = { "prettier" },
                    yaml       = { "prettier" },
                    markdown   = { "prettier" },
                    rust       = { "rustfmt" },
                    c          = { "clang-format" },
                    cpp        = { "clang-format" },
                    xml        = { "lsp" },
                },
                format_on_save = nil, -- use <leader>l= to format manually
            })
        end,
    },

    -----------------------------------------------------------------
    -- Git
    -----------------------------------------------------------------
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs                   = {
                    add          = { text = "│" },
                    change       = { text = "│" },
                    delete       = { text = "_" },
                    topdelete    = { text = "‾" },
                    changedelete = { text = "~" },
                    untracked    = { text = "┆" },
                },
                current_line_blame      = false,
                current_line_blame_opts = {
                    virt_text     = true,
                    virt_text_pos = "eol",
                    delay         = 500,
                },
                sign_priority           = 20,
                update_debounce         = 100,
                max_file_length         = 40000,
            })
        end,
    },
    { "tpope/vim-fugitive" },
    { "rbong/vim-flog" },
    {
        "sindrets/diffview.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
        opts = {
            enhanced_diff_hl = true,
            view = {
                default = {
                    layout = "diff2_horizontal", -- side-by-side
                },
                merge_tool = {
                    layout = "diff3_horizontal", -- 3-way merge view
                    disable_diagnostics = true,
                },
            },
        },
    },

    -----------------------------------------------------------------
    -- Editing helpers
    -----------------------------------------------------------------
    { "numToStr/Comment.nvim", opts = {} },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts  = {},
    },
    {
        "kylechui/nvim-surround",
        version = "*",
        event   = "VeryLazy",
        opts    = {},
    },
    {
        "folke/todo-comments.nvim",
        event        = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts         = {},
    },

    -----------------------------------------------------------------
    -- Terminal
    -----------------------------------------------------------------
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        opts = {
            direction = "horizontal",
            size      = 15,
        },
    },

    -----------------------------------------------------------------
    -- Hex editor
    -----------------------------------------------------------------
    { "RaafatTurki/hex.nvim",  opts = {} },

    -----------------------------------------------------------------
    -- Markdown preview
    -----------------------------------------------------------------
    {
        "iamcco/markdown-preview.nvim",
        cmd    = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft     = { "markdown" },
        build  = "cd app && bash install.sh",
        config = function()
            vim.g.mkdp_auto_close = 1 -- close preview when leaving markdown buffer
            vim.g.mkdp_filetypes  = { "markdown" }
        end,
    },

    -----------------------------------------------------------------
    -- Minimap
    -----------------------------------------------------------------
    {
        "Isrothy/neominimap.nvim",
        lazy = false,
        init = function()
            vim.g.neominimap = {
                auto_enable = true,
                layout      = "float", -- float | split
                float       = {
                    minimap_width = 15,
                    max_minimap_height = nil,
                    margin = { right = 0, top = 0, bottom = 0 },
                    z_index = 1,
                    window_border = "none",
                },
                diagnostic  = {
                    enabled  = true,
                    severity = vim.diagnostic.severity.WARN,
                },
                git         = { enabled = true },
                treesitter  = { enabled = true },
                handlers    = { require("micronoyau.minimap_viewport") },
            }
        end,
    },

    -----------------------------------------------------------------
    -- Smooth scrolling
    -----------------------------------------------------------------
    {
        "karb94/neoscroll.nvim",
        config = function()
            require("neoscroll").setup({
                mappings             = {},   -- all mappings defined manually below
                hide_cursor          = true,
                stop_eof             = true, -- stop at end of file
                respect_scrolloff    = true,
                cursor_scrolls_alone = true,
                duration_multiplier  = 0.5, -- faster than default
                easing               = "sine",
            })

            local ns = require("neoscroll")
            local map = vim.keymap.set
            -- half-page
            map({ "n", "v" }, "<C-d>", function() ns.ctrl_d({ duration = 120 }) end)
            map({ "n", "v" }, "<C-u>", function() ns.ctrl_u({ duration = 120 }) end)
            -- full-page
            map({ "n", "v" }, "<C-f>", function() ns.ctrl_f({ duration = 200 }) end)
            map({ "n", "v" }, "<C-b>", function() ns.ctrl_b({ duration = 200 }) end)
            -- line-by-line
            map({ "n", "v" }, "<C-e>", function() ns.scroll(3, { move_cursor = false, duration = 80 }) end)
            map({ "n", "v" }, "<C-y>", function() ns.scroll(-3, { move_cursor = false, duration = 80 }) end)
            -- paragraph jumps
            map({ "n", "v" }, "zt", function() ns.zt({ half_win_duration = 100 }) end)
            map({ "n", "v" }, "zz", function() ns.zz({ half_win_duration = 100 }) end)
            map({ "n", "v" }, "zb", function() ns.zb({ half_win_duration = 100 }) end)
        end,
    },

    -----------------------------------------------------------------
    -- Smear cursor
    -----------------------------------------------------------------
    {
        "sphamba/smear-cursor.nvim",
        opts = {
            smear_between_buffers            = true,
            smear_between_neighbor_lines     = true,
            scroll_buffer_space              = true,
            legacy_computing_symbols_support = false,
        },
    },

    -----------------------------------------------------------------
    -- Indent guides
    -----------------------------------------------------------------
    {
        "lukas-reineke/indent-blankline.nvim",
        main  = "ibl",
        event = "BufReadPre",
        opts  = {
            indent  = { char = "│" },
            scope   = { enabled = true, show_start = false, show_end = false },
            exclude = {
                filetypes = { "help", "dashboard", "lazy", "mason", "oil" },
            },
        },
    },

    -----------------------------------------------------------------
    -- Jump motions (flash.nvim)
    -----------------------------------------------------------------
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts  = {
            modes = {
                char = { enabled = false }, -- don't override f/t/F/T/;/,
            },
        },
        keys  = {
            { "<leader>c", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash jump" },
            { "<leader>C", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
        },
    },

    -----------------------------------------------------------------
    -- Notification UI (noice.nvim)
    -- Replaces the command line, search, and notifications with
    -- floating windows for a cleaner look
    -----------------------------------------------------------------
    {
        "folke/noice.nvim",
        event        = "VeryLazy",
        dependencies = { "MunifTanjim/nui.nvim" },
        opts         = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"]                = true,
                    ["cmp.entry.get_documentation"]                  = true,
                },
            },
            presets = {
                bottom_search         = true, -- classic bottom search bar
                command_palette       = true, -- position cmdline + popupmenu together
                long_message_to_split = true, -- send long messages to a split
                lsp_doc_border        = true, -- bordered LSP hover/signature
            },
        },
    },

    -----------------------------------------------------------------
    -- Debugging
    -----------------------------------------------------------------
    { "mfussenegger/nvim-dap" },
})
