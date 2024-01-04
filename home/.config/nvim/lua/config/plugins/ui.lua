return {
    --- tokynight configs
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require('tokyonight').setup({
                style = "night",
                transparent = false
            })
            vim.cmd.colorscheme 'tokyonight'
        end,
    },

    --- catppuccinonfigs
    --{
    --    "catppuccin/nvim",
    --    name = "catppuccin",
    --    lazy = false,
    --    priority = 1000,
    --    config = function()
    --        -- vim.cmd.colorscheme 'catppuccin'
    --    end,
    --},

    --- Lualine configurations
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons'
        },
        config = function()
            require('lualine').setup({
                options = {
                    theme = 'tokyonight',
                    -- theme = 'catppuccin',
                    icons_enabled = true,
                },
                sections = {
                    lualine_a = {
                        {
                            'filename',
                            path = 1,
                        }
                    }
                }
            })
        end,
    },
}
