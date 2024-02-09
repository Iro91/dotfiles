--------------------------------------------------------------------------------
-- Indend Blank line
-- Shows ghide alignment where indentation breaks
--------------------------------------------------------------------------------
return {
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufEnter",
        main = "ibl",
        opts = {},
        config = function()
            require("ibl").setup({
                scope = {
                    enabled = false,
                    show_start = false,
                    show_end = false,
                },
            })
        end,
    },
}
