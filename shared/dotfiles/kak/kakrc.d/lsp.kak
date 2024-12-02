# connect kak-lsp to the kakoune session
eval %sh{kak-lsp --kakoune -s $kak_session}
# uncomment to troubleshoot
# set global lsp_cmd "kak-lsp -s %val{session} -vvv --log /tmp/kak-lsp.log"
lsp-enable # is this needed?

# enable for all languages that we want to use the LSP, here we're enabling C++ and Zig.
hook global WinSetOption filetype=(c|cpp|zig|ruby|python) %{
    lsp-enable-window
    # the options below are optional (and self-explanatory)
    set-option window lsp_auto_show_code_actions true
    lsp-code-actions-enable
    lsp-auto-hover-enable
    lsp-auto-signature-help-enable
    lsp-auto-hover-insert-mode-disable

    # potentially buggy
    # https://github.com/kakoune-lsp/kakoune-lsp?tab=readme-ov-file#inlay-hints
    lsp-inlay-hints-enable global
    lsp-inlay-diagnostics-enable global

}

# map global user l %{:enter-user-mode lsp<ret>} -docstring "LSP mode"
# map global insert <tab> '<a-;>:try lsp-snippets-select-next-placeholders catch %{ execute-keys -with-hooks <lt>tab> }<ret>' -docstring 'Select next snippet placeholder'
# map global object a '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
# map global object <a-a> '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
# map global object f '<a-semicolon>lsp-object Function Method<ret>' -docstring 'LSP function or method'
# map global object t '<a-semicolon>lsp-object Class Interface Struct<ret>' -docstring 'LSP class interface or struct'
# map global object d '<a-semicolon>lsp-diagnostic-object --include-warnings<ret>' -docstring 'LSP errors and warnings'
# map global object D '<a-semicolon>lsp-diagnostic-object<ret>' -docstring 'LSP errors'
