return {
    --- Manages installing lsp config servers
    {
        'williamboman/mason.nvim',
        config = function()
            require('mason').setup()
        end
    },

    --- Bridges the gap between neovim and lsps
    -- This will install the LSP server that runs under the hood
    {
        'williamboman/mason-lspconfig.nvim',
        config = function()
            require('mason-lspconfig').setup({
                ensure_installed = { 'lua_ls' }
            })
        end
    },

    --- This final piece has neovim send messages down to the lsp server
    {
        'neovim/nvim-lspconfig',
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({})
        end
    },
}
