# Detection
# ‾‾‾‾‾‾‾‾‾

# hook global BufCreate .*((config.ru)) %{
#     set-option buffer filetype python
# }

# Python linting
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾
hook global WinSetOption filetype=python %{
    # at time of writing, python 3.14 is under preview - kakoune will report the warning as an error
    set-option window lintcmd 'ruff check --preview'
    hook window -group python-lint BufReload .* lint-buffer
    hook window -group python-lint BufWritePost .* lint-buffer
    # These are way too slow
    # hook window -group python-lint NormalIdle .* lint-buffer
    # hook window -group python-lint InsertIdle .* lint-buffer
    hook -once -always window WinSetOption filetype=.* %{
        #remove-hooks window python-lint
    }
}

# Python format
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾
hook global WinSetOption filetype=python %{
    set-option buffer formatcmd 'ruff format --stdin-filename %val{buffile} -'
    set-option window lsp_auto_highlight_references true

    # https://github.com/kakoune-lsp/kakoune-lsp?tab=readme-ov-file#semantic-tokens
    hook window -group semantic-tokens BufReload .* lsp-semantic-tokens
    hook window -group semantic-tokens NormalIdle .* lsp-semantic-tokens
    hook window -group semantic-tokens InsertIdle .* lsp-semantic-tokens
    hook -once -always window WinSetOption filetype=.* %{
        remove-hooks window semantic-tokens
    }


}
# Format on save
# TODO: still not really working :/
hook global BufWritePre .* %{
    try %{
	evaluate-commands -draft %{
            if %opt{filetype} == 'python' %{
                format-buffer
            }
        }
    } catch %{
        # ignore errors from formatter to avoid blocking save
    }
}


# LSP
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook -group lsp-filetype-python global BufSetOption filetype=python %{
    # set-option buffer lsp_servers %{
    #     [ty]
    #     root_globs = ["pyproject.toml", "setup.py", "poetry.lock", ".git", ".hg"]
    #     args = ["server"]
    # }
    set-option buffer lsp_servers %{
        [pyright-langserver]
        root_globs = ["pyproject.toml", "setup.py", "poetry.lock", "pyrightconfig.json", ".git", ".hg"]
        args = ["--stdio"]
    }
    # set-option -add buffer lsp_servers %{
    #     [ruff]
    #     args = ["server", "--quiet"]
    #     root_globs = ["pyproject.toml", "setup.py", "poetry.lock", ".git", ".hg"]
    #     settings_section = "_"
    #     [ruff.settings._.globalSettings]
    #     organizeImports = true
    #     fixAll = true
    # }
}
