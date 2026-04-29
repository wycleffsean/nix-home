# connect kak-lsp to the kakoune session
eval %sh{kak-lsp --kakoune -s $kak_session}
# uncomment to troubleshoot
# set global lsp_cmd "kak-lsp -s %val{session} -vvv --log /tmp/kak-lsp.log"
lsp-enable # is this needed?
lsp-inlay-hints-enable global
lsp-inlay-diagnostics-enable global
lsp-auto-hover-enable

# anchor hover information to cursor instead of clippy
# set-option lsp_hover_anchor global true
set-option global lsp_auto_highlight_references true

# # Define a function to show hover info
# define-command lsp-auto-hover %{
#     evaluate-commands %{
#         try %{ lsp-hover }
#     }
# }

# # Hook to show hover info when stopping in normal mode
# hook global NormalIdle .* %{
#     lsp-auto-hover
# }

# enable for all languages that we want to use the LSP, here we're enabling C++ and Zig.
hook global WinSetOption filetype=(c|cpp|zig|ruby|python) %{
    lsp-enable-window
    # the options below are optional (and self-explanatory)
    set-option window lsp_auto_show_code_actions true
    # lsp-code-actions-enable
    lsp-auto-hover-enable
    lsp-auto-signature-help-enable
    lsp-auto-hover-insert-mode-disable
}

# map global user l %{:enter-user-mode lsp<ret>} -docstring "LSP mode"
# map global insert <tab> '<a-;>:try lsp-snippets-select-next-placeholders catch %{ execute-keys -with-hooks <lt>tab> }<ret>' -docstring 'Select next snippet placeholder'
# map global object a '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
# map global object <a-a> '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
# map global object f '<a-semicolon>lsp-object Function Method<ret>' -docstring 'LSP function or method'
# map global object t '<a-semicolon>lsp-object Class Interface Struct<ret>' -docstring 'LSP class interface or struct'
# map global object d '<a-semicolon>lsp-diagnostic-object --include-warnings<ret>' -docstring 'LSP errors and warnings'
# map global object D '<a-semicolon>lsp-diagnostic-object<ret>' -docstring 'LSP errors'

# Faces

# Base info box
face global InfoDefault               Information

# Code blocks
# face global InfoBlock                 fg=rgb:dddddd,bg=rgb:303030
# face global InfoMono                  fg=rgb:ffd787,bg=rgb:303030

# # Block quotes
# face global InfoBlockQuote            fg=rgb:87afd7,italic

# # Bullets
# face global InfoBullet                fg=rgb:ffaf5f,bold

# # Headers
# face global InfoHeader                fg=rgb:5fd7ff,bold

# # Links
# face global InfoLink                  fg=rgb:87afff,underline
# face global InfoLinkMono              fg=rgb:87afff,underline,bold

# # Horizontal rules
# face global InfoRule                  fg=rgb:5f5f5f

# Diagnostics
# face global InfoDiagnosticError       fg=rgb:ff5f5f,bold
# face global InfoDiagnosticWarning     fg=rgb:ffaf00,bold
# face global InfoDiagnosticInformation fg=rgb:5fd7ff
# face global InfoDiagnosticHint        fg=rgb:87d7af,italic
face global InfoDiagnosticError       DiagnosticError
face global InfoDiagnosticWarning     DiagnosticWarning
face global InfoDiagnosticInformation DiagnosticInfo
face global InfoDiagnosticHint        DiagnosticHint
