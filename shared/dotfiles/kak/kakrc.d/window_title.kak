# https://github.com/mawww/kakoune/wiki/Dynamic-Window-Title
# won't work on 2024.05.18
define-command -hidden bar-buflist %{
    evaluate-commands %sh{
        list=''
        while read buf; do
            if [ "$buf" = '*debug*' ]; then
                continue
            fi
            index=$(($index + 1))
            if [ "$buf" = "$kak_bufname" ]; then
                cur=$(printf '[%s %s]' "$index" "$buf")
            else
                cur=$(printf '%s %s' "$index" "$buf")
            fi
            list="$list $cur"
        done <<<$(printf '%s\n' "$kak_buflist" | tr ' ' '\n')
        title="$list - $kak_client@[$kak_session]"
        printf "set-option -add global ui_options %%{terminal_title=%s}" "$title"
    }
}

hook global WinDisplay .* bar-buflist
