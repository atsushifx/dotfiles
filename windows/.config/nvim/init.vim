"" neovim settings
"" @(#) vim user specific settings[
""
"
" @versiion  1.0.0
" @author    Furukawa, Atsushi <atsushifx@aglabo.com>
" @date      2023-03-26
" @license   MIT
"

""
" viminfo
set viminfofile=$XDG_CACHE_HOME/nvim/_nviminfo


"" for plugins package
set packpath+="$XDG_CONFIG_HOME/nvim"

"" vim common settings
" shell
set shell=pwsh

" encoding : default display Japanese
set fenc=utf-8
set encoding=utf-8
set fileformats=unix


" disp line number
set number

set virtualedit=block
set backspace=indent,eol,start

"" Plugins
" jetpack
" let g:jetpack_download_method = 'curl'
let g:jetpack_download_method = 'git'

" packadd vim-jetpack

" plugins
call jetpack#begin()
Jetpack 'tani/vim-jetpack', { 'opt': 1 }  " bootstrap

" my plugins
Jetpack 'editorconfig/editorconfig-vim'
Jetpack 'wakatime/vim-wakatime'

" file manager
Jetpack 'lambdalisue/fern.vim'
Jetpack 'junegunn/fzf.vim'


call jetpack#end()

