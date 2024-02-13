return {
    --------------------------------------------------------------------------------
    -- Mason is responsible for downloading langauge servers. Fancy curl client
    -- Downloads stuff from the web
    --------------------------------------------------------------------------------
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = function()
            require("mason").setup({
                ui = {
                    border = "rounded",
                },
            })
        end,
    },

    --------------------------------------------------------------------------------
    -- Mason-lspconfig allows for mason to run headless and download servers as needed
    -- 
    -- Acts as an intermediary between mason and lspconfig
    -- Ensures that servers downloaded with mason are correctly configured for 
    -- lspconfig.
    --
    -- When donw this makes sure that the requisite servers are avaialable, however
    -- nvim won't send any messsages over to the ls. That comes with lspconfig
    --------------------------------------------------------------------------------
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        opts = {
            auto_install = true,
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "clangd",
                }
            })
        end
    },

    --------------------------------------------------------------------------------
    -- nvim-lspconfig manages communications between an lsp and our nvim
    -- 
    -- Here is where you want to define key bindings to take actions or navigate
    -- across any code recommendations, issues, or suggestions
    --------------------------------------------------------------------------------
    {
        'neovim/nvim-lspconfig',
        --event = { "BufReadPost" },
        dependencies = {
			-- Plugin and UI to automatically install LSPs to stdpath
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",

			--"hrsh7th/cmp-nvim-lsp",
			-- Install none-ls for diagnostics, code actions, and formatting
			"nvimtools/none-ls.nvim",

			-- Install neodev for better nvim configuration and plugin authoring via lsp configurations
			"folke/neodev.nvim",

			-- Progress/Status update for LSP
			{ "j-hui/fidget.nvim", tag = "legacy" },
        },
        config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				border = "rounded",
				sources = {
					-- formatting
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.diagnostics.shellcheck,

					null_ls.builtins.diagnostics.clangd,
				},
			})

            -- Has to load keymaps before pluginslsp
			--local map_lsp_keybinds = require("user.keymaps").map_lsp_keybinds

			-- Use neodev to configure lua_ls in nvim directories - must load before lspconfig
			require("neodev").setup()

            local lspconfig = require("lspconfig")
            --local capabilities = require('cmp_nvim_lsp').default_capabilities()

            lspconfig.lua_ls.setup({
            --    capabilities = capabilities
            })

            lspconfig.clangd.setup({
                init_options = {
                    compilationDatabasePath = os.getenv("MSW_BUILD_DIR")
                }
            })

            vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
            vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
            vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})

			local formatting = null_ls.builtins.formatting
			--local diagnostics = null_ls.builtins.diagnostics
			--local code_actions = null_ls.builtins.code_actions

			-- Configure borderd for LspInfo ui
			require("lspconfig.ui.windows").default_options.border = "rounded"

			-- Configure diagostics border
			vim.diagnostic.config({
				float = {
					border = "rounded",
				},
			})
        end
    },
}
