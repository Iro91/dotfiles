return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    },
    config = function()
        require("nvim-tree").setup({
            filters = {
                custom = { '.git' }
            }
        })

        -- Always open in exploded view
        local api = require("nvim-tree.api")
        local Event = api.events.Event
        api.events.subscribe(Event.TreeOpen, function()
            api.tree.expand_all()
        end)

        -- Key remapping to show view tree
        vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', {})
    end

}
