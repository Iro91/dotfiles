return {
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        config = function()
            local nnoremap = require("user.keymap_utils").nnoremap
            local gitsigns = require("gitsigns")
            gitsigns.setup()
            require("user.keymap_utils").nnoremap('<leader>gb',  function()
                gitsigns.toggle_current_line_blame()
                end,
                {desc = "Toggle Git Blame" }
            )
        end,
    },
}
