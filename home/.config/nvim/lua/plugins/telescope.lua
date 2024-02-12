return {
    --------------------------------------------------------------------------------
    -- Opens up a telescope ui for sleecting text
    --------------------------------------------------------------------------------
    {
        "nvim-telescope/telescope-ui-select.nvim",
    },
    --------------------------------------------------------------------------------
    -- Gives a fancy search tool for rooting through code
    --------------------------------------------------------------------------------
    {
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
                    },
                    file_igmore_patterns = {
                        ".git"
                    },
                    hidden = true,
                }
            })

            local ts = require('telescope.builtin')
            local skip_find = { ".git/" }
            -- Find all files in the current directory
            vim.keymap.set('n', '<leader>ff', function()
                ts.find_files({ hidden = true, file_ignore_patterns = skip_find })
            end)

            -- List all recent files
            vim.keymap.set('n', '<leader>fr', function()
                ts.oldfiles({ hidden = true, file_ignore_patterns = skip_find })
            end)

            -- List only git files
            vim.keymap.set('n', '<leader>fg', function()
                ts.git_files({ hidden = true, file_ignore_patterns = skip_find })
            end)

            -- vim.keymap.set('n', '<leader>gff', ts.git_files, {})
            -- Search all files in the current directory
            vim.keymap.set('n', '<leader>gf', function()
                local settings = {
                    additional_args = {'--hidden'},
                    glob_pattern = '!.git/'
                }
                ts.live_grep(settings)
            end)

        end
    }
}
