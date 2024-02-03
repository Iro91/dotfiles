-- Single line entry plugins
return {
    'xiyaowong/nvim-transparent', -- toggle ui transpernecy
    build = ":TransperentEnable",
    config = function()
        vim.keymap.set('n', 'TT', ':TransparentToggle<CR>', {noremap=true})
    end
}
