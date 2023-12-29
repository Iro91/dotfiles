return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
        'nvim-lua/plenary.nvim'
    },
    config = function()
        local ts = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', ts.find_files, {})
        vim.keymap.set('n', '<leader>gff', ts.git_files, {})
        vim.keymap.set('n', '<leader>gf', function()
            ts.grep_string({ search = vim.fn.input("Grep > ") })
        end)

        vim.keymap.set('v', '<leader>gm', function()
            ts.grep_string({ search = vim.fn.getline(startLine, endLine) })
        end)
    end
}
