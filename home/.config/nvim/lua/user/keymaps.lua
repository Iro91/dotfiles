-- Use the old vim stype of vim mapping for easier reads
local nnoremap = require("user.keymap_utils").nnoremap
local vnoremap = require("user.keymap_utils").vnoremap
local inoremap = require("user.keymap_utils").inoremap
--local tnoremap = require("user.keymap_utils").tnoremap
--local xnoremap = require("user.keymap_utils").xnoremap

-- Disable the space key as it's reserved by the leader key
nnoremap("<space>", "<nop>")
vnoremap("<space>", "<nop>")

-- Escape insert mode using jk
inoremap('jk', '<escape>')

-- Paste using C-v
inoremap('<C-v>', '<ESC>"+pa')
nnoremap('<C-v>', '"+pa')

-- Visual Mode Mappings
-- Maybe we don't even need this
nnoremap('<leader>y', '"+Y')
vnoremap('<C-c>', '"+Y')
vnoremap('<leader>y', '"+y')

-- Save application with good old <C-S>
nnoremap('<C-S>', ':update<CR>', {silent = true})
vnoremap('<C-S>', '<ESC>:update<CR>', {silent = true})
inoremap('<C-S>', '<ESC>:update<CR>', {silent = true})

-- Jump to beginning of line
nnoremap('H', '^')
vnoremap('H', '^')

-- Jump to end of line
nnoremap('L', '$')
vnoremap('L', '$')

-- Press 'U' for redo
nnoremap("U", "<C-r>")

nnoremap('<leader>c', "<cmd>nohlsearch<CR>")

-- Buffer maangement
nnoremap('<leader>bp', ':bprev<CR>')
nnoremap('<leader>bn', ':bnext<CR>')
nnoremap('<leader>bt', '<C-^>')

-- LSP Keybinds (exports a function to be used in ../../after/plugin/lsp.lua b/c we need a reference to the current buffer) --
local M = {}
M.map_lsp_keybinds = function(buffer_number)
	nnoremap("<leader>rn", vim.lsp.buf.rename, { desc = "LSP: [R]e[n]ame", buffer = buffer_number })
	nnoremap("<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: [C]ode [A]ction", buffer = buffer_number })

	nnoremap("gd", vim.lsp.buf.definition, { desc = "LSP: [G]oto [D]efinition", buffer = buffer_number })

	-- Telescope LSP keybinds --
	nnoremap(
		"gr",
		require("telescope.builtin").lsp_references,
		{ desc = "LSP: [G]oto [R]eferences", buffer = buffer_number }
	)

	nnoremap(
		"gi",
		require("telescope.builtin").lsp_implementations,
		{ desc = "LSP: [G]oto [I]mplementation", buffer = buffer_number }
	)

	nnoremap(
		"<leader>bs",
		require("telescope.builtin").lsp_document_symbols,
		{ desc = "LSP: [B]uffer [S]ymbols", buffer = buffer_number }
	)

	nnoremap(
		"<leader>ps",
		require("telescope.builtin").lsp_workspace_symbols,
		{ desc = "LSP: [P]roject [S]ymbols", buffer = buffer_number }
	)

	-- See `:help K` for why this keymap
	nnoremap("K", vim.lsp.buf.hover, { desc = "LSP: Hover Documentation", buffer = buffer_number })
	nnoremap("<leader>k", vim.lsp.buf.signature_help, { desc = "LSP: Signature Documentation", buffer = buffer_number })
	inoremap("<C-k>", vim.lsp.buf.signature_help, { desc = "LSP: Signature Documentation", buffer = buffer_number })

	-- Lesser used LSP functionality
	nnoremap("gD", vim.lsp.buf.declaration, { desc = "LSP: [G]oto [D]eclaration", buffer = buffer_number })
	nnoremap("td", vim.lsp.buf.type_definition, { desc = "LSP: [T]ype [D]efinition", buffer = buffer_number })
end

return M
