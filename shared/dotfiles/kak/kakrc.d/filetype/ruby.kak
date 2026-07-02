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
try %{ declare-option -hidden str ruby_doc_subject '' }

define-command ruby-doc -params 0.. -docstring 'show Ruby ri docs in the doc client' %{
    require-module ruby-doc
    ruby-doc-run %arg{@}
}

complete-command ruby-doc shell-script-candidates %{ rbdoc --list }

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

define-command -hidden ruby-doc-run -params 0.. %{
    try %{
        evaluate-commands %sh{
            [ "$#" -eq 0 ] && printf %s\\n "fail no doc target" || printf %s\\n "nop"
        }
        evaluate-commands -try-client %opt{docsclient} %sh{
            target="$*"
            buffer_name="*ruby-doc: $target*"
            out=$(mktemp "${TMPDIR:-/tmp}"/kak-ruby-doc.XXXXXX)
            err=$(mktemp "${TMPDIR:-/tmp}"/kak-ruby-doc.XXXXXX)

            rbdoc "$@" > "$out" 2> "$err"
            status=$?

            if [ "$status" -eq 0 ]; then
                printf %s\\n "
                    edit -scratch %{$buffer_name}
                    set-option buffer filetype ruby-doc
                    set-option buffer ruby_doc_subject %{$target}
                    execute-keys '%|cat<space>$out<ret>gk'
                    try %{ ansi-enable }
                    nop %sh{ rm '$out' '$err' }
                "
            else
                printf 'fail %%{%s}\nnop %%sh{ rm '\''%s'\'' '\''%s'\'' }\n' "$(cat "$err")" "$out" "$err"
            fi
        }
        try %{ focus %opt{docsclient} }
    } catch %{
        ruby-doc-search-run
    }
}

define-command -hidden ruby-doc2-run -params 0.. %{
    ruby-doc-run %arg{@}
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

define-command -hidden ruby-doc-jump %{
    try %{
        execute-keys -draft 'x<a-k>^\h*([A-Za-z_][A-Za-z0-9_!?=]*|[+*/%&|^~<>-]+|\[\]=?)(?:\h|$)<ret>'
    } catch %{
        try %{ execute-keys -draft '<a-i>w' }
    }
    evaluate-commands %sh{
        token=$(printf '%s' "$kak_selection" | tr -d '`*[](),')
        base=$(printf '%s' "$kak_opt_ruby_doc_subject" | sed 's/[#.:].*$//; s/[[:space:]].*$//')

        if [ -z "$token" ]; then
            printf '%s\n' 'fail no ruby doc link under cursor'
        elif printf '%s' "$token" | grep -Eq '^[#.][^[:space:]]+$' && [ -n "$base" ]; then
            printf '%s\n' "ruby-doc '$base$token'"
        elif printf '%s' "$token" | grep -Eq '^[A-Z][A-Za-z0-9_:]*([#.][^[:space:]]+)?$|^[a-zA-Z_][A-Za-z0-9_]*[#.][^[:space:]]+$'; then
            printf '%s\n' "ruby-doc '$token'"
        elif [ -n "$base" ]; then
            printf '%s\n' "ruby-doc '$base#$token'"
        else
            printf '%s\n' "ruby-doc '$token'"
        fi
    }
}

hook global WinSetOption filetype=ruby-doc %{
    add-highlighter window/ruby-doc-links regex \b[A-Z][A-Za-z0-9_:]*(?:[#.][A-Za-z0-9_!?=\[\]+\-*/%&|^~<>]+)?\b 0:+u
    add-highlighter window/ruby-doc-method-links regex ^\h*([A-Za-z_][A-Za-z0-9_!?=]*|[+*/%&|^~<>-]+|\[\]=?)(?:\h|$) 1:+u
    map buffer normal <ret> ': ruby-doc-jump<ret>' -docstring 'Open Ruby documentation link'
    hook -once -always window WinSetOption filetype=.* %{
        remove-highlighter window/ruby-doc-links
        remove-highlighter window/ruby-doc-method-links
        unmap buffer normal <ret>
    }
}

§
