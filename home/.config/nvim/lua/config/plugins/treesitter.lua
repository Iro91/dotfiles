return {
    'nvim-treesitter/nvim-treesitter',
    config = function()
        require('nvim-treesitter.configs').setup {
            -- A list of parser names, or "all" (the five listed parsers should always be installed)
            ensure_installed = { "c", "cpp", "python", "lua", "vim", "vimdoc", "query" },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },

            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
            auto_install = true,
        }
    end,
    build = ":TSUpdate"
}
