# configure rust-analyser: we enable zig fmt, reference and semantic highlighting
hook global WinSetOption filetype=rust %{
    set-option buffer formatcmd 'rustfmt --edition 2021'
    # set-option global lsp_server_configuration zls.zig_lib_path="/usr/lib/zig"
    # set-option -add global lsp_server_configuration zls.warn_style=true
    # set-option -add global lsp_server_configuration zls.enable_semantic_tokens=true

    # https://github.com/kakoune-lsp/kakoune-lsp?tab=readme-ov-file#semantic-tokens
    hook window -group semantic-tokens BufReload .* lsp-semantic-tokens
    hook window -group semantic-tokens NormalIdle .* lsp-semantic-tokens
    hook window -group semantic-tokens InsertIdle .* lsp-semantic-tokens
    hook -once -always window WinSetOption filetype=.* %{
        remove-hooks window semantic-tokens
    }
}

hook global BufSetOption filetype=rust %{
    set-option buffer lintcmd 'cargo clippy --message-format=json'
    # To enable auto linting on buffer write
    #hook -group zig-auto-lint buffer BufWritePre .* lint-buffer
    hook -group rust-auto-lint buffer BufWritePre .* lsp-formatting-sync
}
