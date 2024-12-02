# Keybindings borrowed heavily from LazyVim

# User Mappings
map global normal '#' :comment-line<ret>
map global user c %{:edit ~/.config/kak/kakrc<ret>} -docstring 'Edit kakrc'
map global user d %{:edit *debug*<ret>} -docstring 'View *debug* buffer'
map global user o %{:file-browser<ret>} -docstring "Open nnn"
map global user y '<a-|>xsel -i -b<ret>' -docstring "yank selection to clipboard"

map global user l %{:enter-user-mode lsp<ret>} -docstring "LSP mode"
map global insert <tab> '<a-;>:try lsp-snippets-select-next-placeholders catch %{ execute-keys -with-hooks <lt>tab> }<ret>' -docstring 'Select next snippet placeholder'
map global object a '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
map global object <a-a> '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
map global object e '<a-semicolon>lsp-object Function Method<ret>' -docstring 'LSP function or method'
map global object k '<a-semicolon>lsp-object Class Interface Struct<ret>' -docstring 'LSP class interface or struct'

### Commands

# , -> Switch Buffer
# - -> Split window below
# / -> Grep (root dir)
map global user '/' ': require-module fzf-grep; fzf-grep<ret>' -docstring 'Grep (root dir)'
# : -> Command History
# ` -> Switch to Other Buffer
# | -> Split window right
# <space> -> Find Files (root dir)
map global user '<space>' '<esc>: require-module fzf-file; fzf-file<ret>' -docstring "Find Files (root dir)"
# E -> Explorer (cwd)
# e -> Explorer (root dir)
map global user 'e' '<esc>:file-browser<ret>' -docstring "Open file browser (root dir)"
# K -> Keywordprg
# l -> Lazy
# L -> LazyVim Changelog

### Collections

# <tab> -> tabs

## b -> buffer
try %{ declare-user-mode buffers }
define-command -docstring "Enter buffers-mode.
buffers-mode contains keybinds for buffer management
" \
buffers-mode %{ evaluate-commands 'enter-user-mode buffers' }
map global user 'b' ':buffers-mode<ret>' -docstring 'buffer'
# b -> Switch to Other Buffer
# d -> Delete Buffer
# D -> Delete Buffer (Force)
# e -> Buffer explorer
map global buffers -docstring "Buffer explorer" 'e' '<esc>: require-module fzf-buffer; fzf-buffer<ret>'
# l -> Delete buffers to the left
# o -> Delete other buffers
# p -> Toggle pin
# P -> Delete non-pinned buffers
# r -> Delete buffers to the right


## c -> code
## d -> debug
## f -> file/find
## g -> git
## q -> quit/session

## s -> search
try %{ declare-user-mode search }
define-command -docstring "Enter search-mode.
search-mode contains keybinds for searching
" \
search-mode %{ evaluate-commands 'enter-user-mode search' }
map global user 's' ':search-mode<ret>' -docstring 'search'

# " -> Registers
# a -> Auto Commands
# b -> Buffer
# c -> Command History
# C -> Commands
# d -> Document diagnostics
# D -> Workspace diagnostics
# g -> Grep (root dir)
map global search -docstring "Grep (root dir)" 'g' '<esc>:grep '
# G -> Grep (cwd)
# h -> Help Pages
# H -> Search Highlight Groups
# k -> Key Maps
# m -> Jump to Mark
# M -> Man Pages
# o -> Options
# R -> Resume
# r -> Replace in files (Spectre)
# s -> Goto Symbol
# S -> Goto Symbol (Workspace)
# T -> Todo/Fix/Fixme
# t -> Todo
# W -> Word (cwd)
# w -> Word (root dir)
# n -> +noice

## t -> test
try %{ declare-user-mode test }
define-command -docstring "Enter test-mode..
test-mode contains keybinds for testing
" \
test-mode %{ evaluate-commands 'enter-user-mode test' }
map global user 't' ':test-mode<ret>' -docstring 'test'

# d -> Debug Nearest
# l -> Run Last
# o -> Show Output
# O -> Toggle Output Panel
# r -> Run Nearest
map global test -docstring "Run Nearest" 'r' '<esc>:test-run-nearest<ret>'
# S -> Stop
# s -> Toggle Summary
# T -> Run All Test Files
map global test -docstring "Run All Test Files" 'T' '<esc>:test-run-all<ret>'
# t -> Run File
map global test -docstring "Run File" 't' '<esc>:test-run-file<ret>'


## u -> ui
## w -> windows
## x -> diagnostics/quickfix

# Non-Lazy Vim binds
map global user m %{:enter-user-mode man<ret>} -docstring "manpage mode"
map global user p %{:enter-user-mode clipboard<ret>} -docstring "clipboard"
