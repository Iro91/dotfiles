-- NOTE: There is no plugin that manages automatically installing formatters and
-- linters. To add new content, please install using Mason
return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.diagnostics.shellcheck,
			},
		})

		vim.keymap.set("n", "<leader>fd", vim.lsp.buf.format, {})
	end,
}
