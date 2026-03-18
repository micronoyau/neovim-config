-- Custom neominimap handler: highlights the currently visible viewport region.
-- One highlight group ("NeominimapViewport") spans the lines visible in the
-- focused source window, giving the VSCode-style shaded region on the minimap.

local api = vim.api

-- Store the visible range per buffer (last focused window wins).
---@type table<integer, {top: integer, bot: integer}>
local ranges = {}

local ns = api.nvim_create_namespace("neominimap_viewport")

-- Ensure the highlight group exists (links to a subtle background colour).
api.nvim_set_hl(0, "NeominimapViewport", { link = "Visual", default = true })

---@type Neominimap.Map.Handler
local handler = {
    name      = "viewport",
    mode      = "line",
    namespace = ns,

    init = function() end,

    autocmds = {
        {
            -- Fires when the editor window is scrolled or resized.
            event = { "WinScrolled", "BufWinEnter", "WinEnter", "CursorMoved" },
            opts  = {
                desc = "Update viewport highlight on the minimap",
                callback = function(apply, args)
                    local winid = api.nvim_get_current_win()
                    -- Skip minimap windows (they have no normal buffer).
                    local cfg = api.nvim_win_get_config(winid)
                    if cfg.relative ~= "" then return end

                    local bufnr = api.nvim_win_get_buf(winid)
                    local top   = vim.fn.line("w0", winid)
                    local bot   = vim.fn.line("w$", winid)

                    local prev = ranges[bufnr]
                    if prev and prev.top == top and prev.bot == bot then return end

                    ranges[bufnr] = { top = top, bot = bot }
                    apply(bufnr)
                end,
            },
        },
    },

    get_annotations = function(bufnr)
        local r = ranges[bufnr]
        if not r then return {} end
        return {
            {
                id        = 1,
                lnum      = r.top,
                end_lnum  = r.bot,
                priority  = 50,
                highlight = "NeominimapViewport",
            },
        }
    end,
}

return handler
