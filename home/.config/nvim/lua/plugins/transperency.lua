----------------------------------------------------------------------
-- Enables a the background to go completely transparent
----------------------------------------------------------------------
return {
    'xiyaowong/nvim-transparent', -- toggle ui transpernecy
    config = function()
        require("transparent").setup {
            extra_groups = {
                "NormalFloat", -- Floating plugins like Lazy or Noice
                "NvimTreeNromal" -- NvimTree
            }
        }
        vim.keymap.set('n', 'TT', ':TransparentToggle<CR>', {noremap=true})
    end,
}
