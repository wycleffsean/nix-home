# Detection
# ‾‾‾‾‾‾‾‾‾

# hook global BufCreate .*((config.ru)) %{
#     set-option buffer filetype python
# }


# LSP
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

# Make this file authoritative for Python LSPs.
# Prevent kak-lsp's default Python hook from starting pylsp/ty first.
remove-hooks global lsp-filetype-python

# Buffer-scoped setup: safe place for buffer options and save hooks.
hook -group lsp-filetype-python global BufSetOption filetype=python %{
    set-option buffer lsp_servers %{
        # [pyright-langserver]
        # root_globs = ["pyproject.toml", "uv.lock", "setup.py", "setup.cfg", "pyrightconfig.json", ".git", ".hg"]
        # args = ["--stdio"]

        [ty]
        root_globs = ["pyproject.toml", "uv.lock", "setup.py", "setup.cfg", "pyrightconfig.json", ".git", ".hg"]
        args = ["server"]

        [ruff]
        root_globs = ["pyproject.toml", "ruff.toml", ".ruff.toml", "uv.lock", ".git", ".hg"]
        args = ["server"]
    }

    # Ruff owns fix/import/format on save.
    # Pyright owns type checking, hover, completion, navigation.
    hook buffer -group python-lsp-save BufWritePre .* %{
        try %{ lsp-code-action-sync source.fixAll.ruff }
        try %{ lsp-code-action-sync source.organizeImports.ruff }
        try %{ lsp-formatting-sync }
    }

    hook -once -always buffer BufSetOption filetype=.* %{
        remove-hooks buffer python-lsp-save
    }
}


# Window-local Python UI behavior
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
hook -group python-window global WinSetOption filetype=python %{
    set-option window lsp_auto_highlight_references true
    set-option window lsp_auto_show_code_actions true

    # Optional manual lint command. LSP diagnostics should be primary,
    # but :lint remains useful when you want an explicit Ruff check.
    set-option window lintcmd 'ruff check --preview --stdin-filename %val{buffile} -'

    # Keep passive linting modest. Ruff LSP already reports diagnostics.
    # hook window -group python-ops BufReload .* lint-buffer
    # hook window -group python-ops BufWritePost .* lint-buffer

    # Semantic tokens from LSP.
    hook window -group semantic-tokens BufReload .* lsp-semantic-tokens
    hook window -group semantic-tokens NormalIdle .* lsp-semantic-tokens
    hook window -group semantic-tokens InsertIdle .* lsp-semantic-tokens

    hook -once -always window WinSetOption filetype=.* %{
        remove-hooks window python-ops
        remove-hooks window semantic-tokens
    }
}
