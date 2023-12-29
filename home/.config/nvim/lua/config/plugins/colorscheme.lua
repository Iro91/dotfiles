return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = function() 
            return {
                style = "storm",
                transparent = true
            }
        end,
        config = function()
            vim.cmd([[colorscheme tokyonight]])
            vim.api.nvim_set_hl(0, "Normal", {bg = "none"})
            vim.api.nvim_set_hl(0, "NormalFloat", {bg = "none"})
        end,
    },
}
