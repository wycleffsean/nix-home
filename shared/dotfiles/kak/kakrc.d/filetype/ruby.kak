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

try %{ declare-option -docstring "name of the client in which documentation is displayed" str docsclient docs }

define-command ruby-doc -params 0.. -docstring 'show Ruby ri docs in the doc client' %{
    require-module ruby-doc
    ruby-doc-run %arg{@}
}

# hook -group rake-commands global WinSetOption filetype=ruby %{
#     evaluate-commands %sh{
#         rake -T | tr ':' '-'
#     }
# }



define-command ruby-doc2 -params 0.. -docstring 'show Ruby ri docs in the doc client' %{
    require-module ruby-doc
    ruby-doc2-run %arg{@}
}

define-command ruby-doc-search -params 0.. -docstring 'search Ruby ri docs in the doc client' %{
    require-module ruby-doc
    ruby-doc-search-run %arg{@}
}

provide-module ruby-doc %§

require-module kakpipe

define-command -hidden ruby-doc-run -params 0.. %{
    try %{
        evaluate-commands %sh{
            [ "$#" -eq 0 ] && printf %s\\n "fail no doc target" || printf %s\\n "nop"
        }
        evaluate-commands -try-client %opt{docsclient} %{
            kakpipe -S -n ruby-doc -D filetype=man -- rbdoc %arg{@}
        }
        try %{ focus %opt{docsclient} }
    } catch %{
        ruby-doc-search-run
    }
}

define-command -hidden ruby-doc2-run -params 0.. %{
    evaluate-commands -try-client %opt{docsclient} %{
        kakpipe -S -n ruby-doc2 -D filetype=man -- rbdoc %arg{@}
    }
    try %{ focus %opt{docsclient} }
}

define-command -hidden ruby-doc-search-run -params 0.. %{
    require-module fzf
    evaluate-commands %sh{
        if [ "$#" -eq 0 ]; then
            printf %s\\n "fzf -items-cmd %{rbdoc --list} -kak-cmd %{ruby-doc}"
        else
            query=$(printf "%s" "$*" | sed "s/'/'\\\\''/g")
            printf %s\\n "fzf -items-cmd %{rbdoc --list} -kak-cmd %{ruby-doc} -fzf-args %{--query '$query'}"
        fi
    }
}

§
