return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons'
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        telescope.setup({
            defaults = {
                mappings = {
                    i = {
                        ['<C-k>'] = actions.move_selection_previous, --move up
                        ['<C-j>'] = actions.move_selection_next, -- move down
                    }
                }
            }
        })

        local ts = require('telescope.builtin')
        local keymap = vim.keymap
        local skip_find = { ".git/" }
        -- Find all files in the current directory
        keymap.set('n', '<leader>ff', function() 
            ts.find_files({ hidden = true, file_ignore_patterns = skip_find })
        end)

        -- List all recent files
        keymap.set('n', '<leader>fr', function() 
            ts.oldfiles({ hidden = true, file_ignore_patterns = skip_find })
        end)

        -- List only git files
        keymap.set('n', '<leader>fg', function() 
            ts.git_files({ hidden = true, file_ignore_patterns = skip_find })
        end)

        -- keymap.set('n', '<leader>gff', ts.git_files, {})
        -- Search all files in the current directory
        keymap.set('n', '<leader>gf', function()
            local settings = { 
                additional_args = {'--hidden'},
                glob_pattern = '!.git/'
            }
            ts.live_grep(settings)
        end)

        keymap.set('v', '<leader>gm', function()
            ts.grep_string({ search = vim.fn.getline(startLine, endLine) })
        end)
    end
}
