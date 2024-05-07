"set runtimepath^=~/.vim runtimepath+=~/.vim/after
"let &packpath = &runtimepath
"source ~/.vimrc

" Vundle
set nocompatible "required
filetype off "required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" Let Vundle manage itself
Plugin 'gmarik/Vundle.vim'

" Plugins
if !has('nvim')
Plugin 'ctrlpvim/ctrlp.vim'
endif
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'bling/vim-airline'
"Plugin 'kchmck/vim-coffee-script'
"Plugin 'elmcast/elm-vim'
"Plugin 'fatih/vim-go'
"Plugin 'mtscout6/vim-cjsx'
Plugin 'tpope/vim-fugitive'
Plugin 'junegunn/vim-easy-align'
Plugin 'majutsushi/tagbar'
"Plugin 'ludovicchabant/vim-gutentags'
"Plugin 'neoclide/coc.nvim' " nixed in favor of nvim lsp
"Plugin 'dense-analysis/ale' " nixed in favor of
"Plugin 'LnL7/vim-nix'

if has('nvim')
" lsp
Plugin 'neovim/nvim-lspconfig'
Plugin 'hrsh7th/cmp-nvim-lsp'
Plugin 'hrsh7th/nvim-cmp'
Plugin 'hrsh7th/cmp-vsnip'
Plugin 'hrsh7th/vim-vsnip'
Plugin 'ziglang/zig.vim'
Plugin 'kyazdani42/nvim-web-devicons' " for Trouble
Plugin 'folke/trouble.nvim' " better error diagnostics

" Telescope
Plugin 'nvim-lua/plenary.nvim'
Plugin 'nvim-telescope/telescope.nvim'
Plugin 'nvim-telescope/telescope-fzf-native.nvim'

Plugin 'renerocksai/telekasten.nvim'
endif

" Colorschemes
Plugin 'endel/vim-github-colorscheme' "pretty diffs
Plugin 'KeitaNakamura/neodark.vim'

" Required, plugins available after
call vundle#end()
filetype plugin indent on

set nocompatible " Turn off vi compatibility
set smartindent
set autoindent
"filetype indent on " load indent file for the current filetype

set laststatus=2
set number
set showcmd
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
set splitbelow
set splitright
set backspace=2 "make backspace work like most other apps
set ignorecase          " searches are case insensitive...
set smartcase           " ... unless they contain at least one capital letter
set expandtab
set shiftwidth=2
set softtabstop=2
"set t_ti= t_te= " don't clobber scrollbuffer
set hlsearch
"if exists('+colorcolumn')
"   set colorcolumn=80
"else
"  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
"endif
let &colorcolumn=join(range(81,81),",")

autocmd Filetype html setlocal ts=2 sts=2 sw=2
autocmd Filetype ruby setlocal sts=2 sw=2
autocmd Filetype elm setlocal sts=4 sw=4 noignorecase
autocmd Filetype python setlocal sts=4 sw=4 ts=4
" Align GitHub-flavored Markdown tables
autocmd FileType markdown vmap <Leader><Bslash> :EasyAlign*<Bar><Enter>

" Tiltfile
autocmd BufRead,BufNewFile Tiltfile setfiletype tiltfile
autocmd BufRead,BufNewFile Tiltfile setlocal syntax=python
autocmd Filetype tiltfile set syntax=python " feels like it should work but doesn't

syntax on

let g:airline#extension#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t' "only show filename
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

if !has('nvim')
  " let g:ctrlp_map = '<D-p>'
  let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
  let g:ctrlp_dont_split = 'NERD_tree_1'
  let g:ctrlp_extensions = ['tag']
  nmap <leader>p :CtrlPTag<CR>
endif

let g:elm_setup_keybindings = 0

if executable('rg')
  " Use ripgrep over ag
  set grepprg=rg\ --vimgrep\ --no-heading\ --sort-files
  set grepformat=%f:%l:%c:%m,%f:%l:%m
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
elseif executable('ag')
  " Use ag over grep
  set grepprg=ag
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  let g:ctrlp_use_caching = 0
endif

" bind \ to grep shortcut
command -nargs=+ -complete=file -bar Grep silent! grep! <args>|cwindow|redraw!
nnoremap \ :Grep<SPACE>

" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>


" Colors
colorscheme neodark
if &diff
  colorscheme github
endif

" mappings
"set winminheight=0
"set winheight=999
"nmap <c-h> <c-w>h<c-w>_
"nmap <c-j> <c-w>j<c-w>_
"nmap <c-k> <c-w>k<c-w>_
"nmap <c-l> <c-w>l<c-w>_


" Leader Mappings
let mapleader = " "
map <leader>k :NERDTree<cr>
nmap <leader>t :TagbarToggle<CR>

" " Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" " Paste from clipboard
"nnoremap <leader>p "+p
"nnoremap <leader>P "+P
"vnoremap <leader>p "+p
"vnoremap <leader>P "+P

" Ruby
" puts the caller
nnoremap <leader>wtf oputs "#" * 90<c-m>p caller<c-m>puts "#" * 90<esc>

" ######
" NEOVIM
" ######
if has('nvim')
  "set termguicolors
  "let g:python_host_prog = '/usr/local/bin/python2'

  " Reload files when modified outside of editor
  " i.e. git
  " https://github.com/neovim/neovim/issues/2127#issuecomment-150954047
  augroup AutoSwap
          autocmd!
          autocmd SwapExists *  call AS_HandleSwapfile(expand('<afile>:p'), v:swapname)
  augroup END

  function! AS_HandleSwapfile (filename, swapname)
          " if swapfile is older than file itself, just get rid of it
          if getftime(v:swapname) < getftime(a:filename)
                  call delete(v:swapname)
                  let v:swapchoice = 'e'
          endif
  endfunction
  autocmd CursorHold,BufWritePost,BufReadPost,BufLeave *
    \ if isdirectory(expand("<amatch>:h")) | let &swapfile = &modified | endif

  augroup checktime
      au!
      if !has("gui_running")
          "silent! necessary otherwise throws errors when using command
          "line window.
          autocmd BufEnter,CursorHold,CursorHoldI,CursorMoved,CursorMovedI,FocusGained,BufEnter,FocusLost,WinLeave * checktime
      endif
  augroup END

  " Find files using Telescope command-line sugar.
  nnoremap <leader>p <cmd>Telescope find_files<cr>
  nnoremap <leader>fg <cmd>Telescope live_grep<cr>
  nnoremap <leader>] <cmd>Telescope grep_string<cr>
  nnoremap <leader>fb <cmd>Telescope buffers<cr>
  nnoremap <leader>fh <cmd>Telescope help_tags<cr>
  nnoremap <leader>t <cmd>Telescope lsp_document_symbols<cr>
  cmap <C-R> <Plug>(TelescopeFuzzyCommandSearch)

  " Using Lua functions
  " nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
  " nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
  " nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
  " nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
  "

  require('telekasten').setup({
    home = vim.fn.expand("~/.notes"), -- Put the name of your notes directory here
  })

lua << EOF
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- require'lspconfig'.solargraph.setup{}
  require'lspconfig'.sorbet.setup{ capabilities = capabilities, cmd = { "bin/srb", "tc", "--lsp", "--disable-watchman" } }
  require'lspconfig'.tsserver.setup{ capabilities = capabilities }
  require'lspconfig'.zls.setup{ capabilities = capabilities }
  require'lspconfig'.jedi_language_server.setup{ capabilities = capabilities }
  require'lspconfig'.tilt_ls.setup{ capabilities = capabilities }
  require("trouble").setup{
    auto_open = true,
    auto_close = true,
  }

  local telescope = require('telescope');
  telescope.load_extension('fzf')

  local actions = require("telescope.actions")
  local trouble = require("trouble.providers.telescope")

  telescope.setup {
    defaults = {
      mappings = {
        i = { ["<c-t>"] = trouble.open_with_trouble },
        n = { ["<c-t>"] = trouble.open_with_trouble },
      },
    },
  }

  print(vim.lsp.get_log_path())

  -- Setup nvim-cmp.
-- --[[  
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    mapping = {
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<Tab>'] = cmp.mapping.select_next_item(),
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Setup lspconfig.
  -- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  -- require('lspconfig')['solargraph'].setup { capabilities = capabilities }
  -- require('lspconfig')['sorbet'].setup { capabilities = capabilities }
-- --]]  
EOF
endif
