return {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
    event = { "BufEnter" },
    dependencies = {
      -- Additional text objects for treesitter
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
        require('nvim-treesitter.configs').setup {
            -- A list of parser names, or "all" (the five listed parsers should always be installed)
            ensure_installed = {
                "bash",
                "c",
                "cpp",
                "json",
                "lua",
                "markdown",
                "python",
                "lua",
                "vim",
                "vimdoc",
                "query",
                "vim",
            },
            sync_install = false,
            highlight = {
                enable = true
            },
            indent = {
                enable = true
            },

            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
            auto_install = true,
        }
    end,
    build = ":TSUpdate"
}
