syntax on                           " Mantem sintax ligado

set noerrorbells                    " Remove som de erros
set tabstop=4                       " Espaco de tab igual a 4
set shiftwidth=4                    " Tab de 4 espacos para > e <
set scrolloff=8                     " Scroll ofset, 8 lines
set number                          " Numero nas linhas
set norelativenumber                " Linhas relativas
set smartindent                     " Tenta deixar a indentacao correta
set nowrap                          " Linha continua
set smartcase                       " Case sensitivi para busacas i
set noswapfile                      " Sem arquivos de swap para o vim
set nobackup                        " Remove arquivo de backou
set undodir=~/.vim/undodir          " Arquivo de undo armazenados nessa pasta
set undofile                        " Para cada arquivo
set incsearch                       " Destaca a busaca no texto
set pastetoggle=<F2>                " Ativa e desativo modo copia
command! Xs :mks! | :xa             " Save the session, save modified files, and exit

" set colorcolumn=80                " Habilita uma linha inndicativa de 80 chars, comando qua define a cor a baixo
" highlight ColorColumn ctermbg=0 guibg=lightgrey

call plug#begin('~/.vim/plugged')   " Inicio da chamada do plugin maneger

Plug 'neoclide/coc.nvim', {'branch': 'release'} " Auto complete and more
Plug 'mattn/emmet-vim'              " Emmet para o vim
Plug 'scrooloose/nerdtree'          " File tree
Plug 'terryma/vim-multiple-cursors' " Multiplos cursors
Plug 'w0rp/ale'                     " Integrador de linters
" Plug 'ycm-core/YouCompleteMe'       " Auto compleat
Plug 'morhetz/gruvbox'              " Theme grovbox
Plug 'jremmen/vim-ripgrep'          " grep search de forma rapida
Plug 'vim-utils/vim-man'            " man page vim
Plug 'luochen1990/rainbow'          " showing diff level of parentheses in diff color

call plug#end()                     " Fim da chamada

let g:rainbow_active = 1            " set to 0 if you want to enable it later via :RainbowToggle
let g:gruvbox_contrast_dark = 'hard'
colorscheme gruvbox                 " Seleciona o tema
set background=dark                 " bg color


map <silent> <C-b> :NERDTreeToggle<CR>       " Show file tree

map <silent> <C-h> :wincmd h<CR>             " move para o buffer da esquerda
map <silent> <C-l> :wincmd l<CR>             " move para o buffer da direita
nmap <silent> <C-k><C-k> :set invrelativenumber <CR> " Ctrl-k duas vezes, ativa e desativa linha relativa ao cursor

" Comment Box
nnoremap <leader>* I*<Space><Esc>A<Space>*<ESC>I<ESC><C-V>$U<Esc>yy2P<C-V>$r*i/<ESC>jI<SPACE><ESC>j<C-V>$r*A/<ESC>I<SPACE><c-o>o<c-o>I

" Remove sapces
augroup DEFAULT_FILES
    autocmd!
    autocmd BufWritePre * %s/\s\+$//e
augroup END

autocmd FileType vue setlocal tabstop=2 shiftwidth=2 expandtab

function ReloadSyntax()
  syntax sync fromstart
  echom "Syntax reloaded!"
endfunction

"------------------------------- Abreviations ------------------------------------

iabbrev t_link <link rel="stylesheet" type="text/css" href="%"><Esc>F%s<c-o>:call getchar()<CR>
iabbrev t_script <script type="text/javascript" src="%"></script><Esc>F%s<c-o>:call getchar()<CR>
iabbrev t_html <ESC><F2>i<!DOCTYPE html><CR><html lang="en"><CR><head><CR><TAB><meta charset="UTF-8"><CR><TAB><meta http-equiv="X-UA-Compatible" content="IE=edge"><CR><TAB><meta name="viewport" content="width=device-width, initial-scale=1.0"><CR><TAB><title>%</title><CR></head><CR><body><CR><CR><CR></body><CR></html><c-o>6k<c-o>A<ESC>F%s<c-o>:call getchar()<CR><ESC><F2>
iabbrev *{ <ESC><F2>i*{<CR><TAB>margin: 0;<CR><TAB>padding: 0;<CR><TAB>box-sizing: border-box;<CR>}<ESC><F2>i
iabbrev log@ console.log(%);<ESC>F%s<c-o>:call getchar()<CR>

"---------------------------------- COC Configs ----------------------------------

" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
