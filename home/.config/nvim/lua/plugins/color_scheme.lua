return {
    --- tokyonight configs
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require('tokyonight').setup({
                style = "night",
                transparent = vim.g.transparent_enabled,
                styles = {
                    sidebars = "transparent",
                    floats = "transparent",
                }
            })
            vim.cmd.colorscheme("tokyonight")
        end,
    },

    -- catpuccin colorscheme
    {
        "catppuccin/nvim",
        config = function()
            require("catppuccin").setup({
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    harpoon = true,
                    illuminate = true,
                    indent_blankline = {
                        enabled = false,
                        scope_color = "sapphire",
                        colored_indent_levels = false,
                    },
                    mason = true,
                    native_lsp = { enabled = true },
                    notify = true,
                    nvimtree = true,
                    neotree = true,
                    symbols_outline = true,
                    telescope = true,
                    treesitter = true,
                    treesitter_context = true,
                },
            })

            -- vim.cmd.colorscheme("catppuccin-macchiato")
        end,
    },

}
