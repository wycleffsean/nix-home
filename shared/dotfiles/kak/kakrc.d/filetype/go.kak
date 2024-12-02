# Detection
# ‾‾‾‾‾‾‾‾‾

# configure zls: we enable zig fmt, reference and semantic highlighting
# hook global WinSetOption filetype=zig %{
#     set-option buffer formatcmd 'zig fmt --stdin'
#     set-option window lsp_auto_highlight_references true
#     set-option global lsp_server_configuration zls.zig_lib_path="/usr/lib/zig"
#     set-option -add global lsp_server_configuration zls.warn_style=true
#     set-option -add global lsp_server_configuration zls.enable_semantic_tokens=true
#     hook window -group semantic-tokens BufReload .* lsp-semantic-tokens
#     hook window -group semantic-tokens NormalIdle .* lsp-semantic-tokens
#     hook window -group semantic-tokens InsertIdle .* lsp-semantic-tokens
#     hook -once -always window WinSetOption filetype=.* %{
#         remove-hooks window semantic-tokens
#     }
# }

# hook global BufSetOption filetype=zig %{
#     set-option buffer lintcmd 'zig fmt --color off --ast-check 2>&1'
#     # To enable auto linting on buffer write
#     #hook -group zig-auto-lint buffer BufWritePre .* lint-buffer
#     hook -group zig-auto-lint buffer BufWritePre .* lsp-formatting-sync
# }


# We use lintcmd and formatcmd because it's simple, but there are LSP alternatives to this
# like e.g. :lsp-formatting. It's potentially less efficient, but easier and less janky

hook global WinSetOption filetype=go %{
    # TODO: https://golangci-lint.run/welcome/install/#install-from-sources
    # set-option buffer lintcmd ''
    set-option window formatcmd 'gopls format'

    set-option window lsp_auto_highlight_references true

    # https://github.com/kakoune-lsp/kakoune-lsp?tab=readme-ov-file#semantic-tokens
    hook window -group semantic-tokens BufReload .* lsp-semantic-tokens
    hook window -group semantic-tokens NormalIdle .* lsp-semantic-tokens
    hook window -group semantic-tokens InsertIdle .* lsp-semantic-tokens
    hook -once -always window WinSetOption filetype=.* %{
        remove-hooks window semantic-tokens
    }

    # hook -once -always window WinSetOption filetype=.* %{
    #     remove-hooks window go-buffer
    # }
}

hook global BufSetOption filetype=go %{
    map buffer user 'a' :go-alternative-file<ret> -docstring 'Switch to alternative file (e.g. test)'
}
