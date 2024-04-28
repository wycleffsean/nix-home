declare-option str barcmd 'lemonbar'
declare-option str bar_buflist

define-command bar-create %{
  %sh{
    {
      fifo=/tmp/kakoune/bar_$kak_session
      rm "$fifo"
      mkfifo "$fifo"
      exec 3<> "$fifo"
      cat "$fifo" | $kak_opt_barcmd -p -B '#282a36' -F '#f8f8f2' -f 'Monospace:size=9' &
    } >/dev/null 2>&1 </dev/null &
  }
  bar-refresh-buflist
}

define-command bar-refresh -params 1 %{
  %sh{
    fifo=/tmp/kakoune/bar_$kak_session
    if [ -p "$fifo" ]; then
      echo "$1" > "$fifo"
    fi
  }
}

define-command bar-destroy %{ %sh{
  fifo=/tmp/kakoune/bar_$kak_session
  rm "$fifo"
} }

hook global KakEnd .* %{ %sh{
  bar-destroy
} }

# Example with buflist

define-command -hidden bar-bufflist %{
  %sh{
    list=''
    while read buf; do
      index=$(($index + 1))
      if [ "$buf" = "$kak_bufname" ]; then
        # markup specific to lemonbar
        list="$list %{R} $index $buf %{R}"
      else
        list="$list  $index $buf "
      fi
    done <<< $(printf '%s\n' "$kak_buflist" | tr ':' '\n')
    #echo "set-option global bar_buflist '$list'"
  }
}

define-command bar-refresh-buflist %{
  bar-bufflist
  bar-refresh %opt{bar_buflist}
}

# Suggested hooks

hook global WinDisplay .* bar-refresh-buflist
