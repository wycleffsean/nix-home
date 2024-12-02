# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*((config.ru)) %{
    set-option buffer filetype ruby
}

# Ruby linting
hook global WinSetOption filetype=ruby %{
    set-option window lintcmd 'bin/standardrb --display-cop-names --force-exclusion --format emacs --cache false'
    hook window -group ruby-lint BufReload .* lint-buffer
    hook window -group ruby-lint BufWritePost .* lint-buffer
    # These are way too slow
    # hook window -group ruby-lint NormalIdle .* lint-buffer
    # hook window -group ruby-lint InsertIdle .* lint-buffer
    hook -once -always window WinSetOption filetype=.* %{
        #remove-hooks window ruby-lint
    }
}

hook global BufSetOption filetype=ruby %{
    map buffer user 'a' :ruby-alternative-file<ret> -docstring 'Switch to alternative file (e.g. test)'
    set-option	buffer indentwidth 2
}

# hook -group rake-commands global WinSetOption filetype=ruby %{
#     evaluate-commands %sh{
#         rake -T | tr ':' '-'
#     }
# }

