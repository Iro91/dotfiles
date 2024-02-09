----------------------------------------------------------------------
-- Enables a the background to go completely transparent
----------------------------------------------------------------------
return {
    'xiyaowong/nvim-transparent', -- toggle ui transpernecy
    config = function()
        vim.keymap.set('n', 'TT', ':TransparentToggle<CR>', {noremap=true})
    end,
    build = ":TransperentEnable",
}
