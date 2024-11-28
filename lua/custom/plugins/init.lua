-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  { 'wakatime/vim-wakatime' },
  { 'simnalamburt/vim-mundo' },
  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },
  { 'bullets-vim/bullets.vim', lazy = true, ft = 'markdown' }, -- https://github.com/bullets-vim/bullets.vim
  { 'echasnovski/mini.nvim', version = '*', lazy = true }, -- https://github.com/echasnovski/mini.surround
}
