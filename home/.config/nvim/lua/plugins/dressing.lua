--------------------------------------------------------------------------------
-- Make floating windows prettier
--------------------------------------------------------------------------------
return {
    {
        "stevearc/dressing.nvim",
        config = function()
            require("dressing").setup()
        end,
    },
}
