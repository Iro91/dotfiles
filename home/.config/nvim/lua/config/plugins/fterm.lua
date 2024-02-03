return {
    'numToStr/FTerm.nvim',
    config = function()
        local keymap = vim.keymap
        require 'FTerm'.setup({
            blend = 5,
            dimensions = {
                height = 0.90,
                width = 0.90,
                x = 0.5,
                y = 0.5
            }
        })
    end
}
