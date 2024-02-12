--------------------------------------------------------------------------------
-- Opens a directory search
--------------------------------------------------------------------------------
return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    },
    config = function()
        local HEIGHT_RATIO = .8
        local WIDTH_RATIO = .8

        require("nvim-tree").setup({

            disable_netrw = true,
            hijack_netrw = true,
            view = {
                relativenumber = true,

                -- Set the nvim tree to be floating. Disabled as this currently
                -- causes an issue when noice posts messages
                --float = {
                --    enable = true,
                --    open_win_config = function()
                --        local screen_w = vim.opt.columns:get()
                --        local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                --        local window_w = screen_w * WIDTH_RATIO
                --        local window_h = screen_h * HEIGHT_RATIO
                --        local window_w_int = math.floor(window_w)
                --        local window_h_int = math.floor(window_h)
                --        local center_x = (screen_w - window_w) / 2
                --        local center_y = ((vim.opt.lines:get() - window_h) / 2)
                --        - vim.opt.cmdheight:get()
                --        return {
                --            border = "rounded",
                --            relative = "editor",
                --            row = center_y,
                --            col = center_x,
                --            width = window_w_int,
                --            height = window_h_int,
                --        }
                --    end,
                --},
                --width = function()
                --    return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
                --end,
            },
            actions = {
                open_file = {
                    quit_on_open = true,
                }
            },
            filters = {
                custom = { '.git' }
            }
        })

        -- Key remapping to toggle view tree
        vim.keymap.set('n', '<leader>tt',  ':NvimTreeToggle<CR>', {})

        -- Reset the nvim tree so that the tree will refresh
        local nt = require("nvim-tree.api")
        local function openNvimTreeAtPath(target)
            nt.tree.close()
            print(target)
            nt.tree.open({ path = target} )
        end

        -- Open back to the root directory where vim was opened from
        vim.keymap.set('n', '<leader>tr', function()
            openNvimTreeAtPath(vim.fn.getcwd())
        end, {})

        -- Open relative to wherever the current buffer was selected
        vim.keymap.set('n', '<leader>tl', function()
            openNvimTreeAtPath(vim.fn.expand("%:p:h"))
        end, {})
    end

}
