declare-option -docstring "shell command run for file management" \
    str filemancmd 'nnn -p -'
    # maybe these are reasonable options as well
    # - https://github.com/ranger/ranger
    # - https://github.com/kyoheiu/felix
    # - https://github.com/kamiyaa/joshuto
    # - https://github.com/sxyazi/yazi

# TODO: we can do detection for filemanagers like the kak windowing modules
# https://github.com/mawww/kakoune/blob/master/rc/windowing/detection.kak

# set global filemancmd 'yazi --chooser-file=/dev/stdout'

provide-module fileman %{

define-command nnn -params .. -docstring 'nnn: open an nnn file browser' %{
    # NNN_OPENER='kak -c %val{session}'
    # terminal nnn -e
    terminal "KAK_SESSION=%val{session} KAK_CLIENT=%val{client} nnn"
}

define-command file-browser -params 0..1 -file-completion -docstring 'Open filemanager in path of current buffer' %{
    terminal sh -c %{
        kak_filemancmd=$1 kak_buffile=$2 kak_session=$3 kak_client=$4
        shift 4
        kak_pwd="${@:-$(dirname "${kak_buffile}")}"
        filename=$($kak_filemancmd "${kak_pwd}")
        # >&2 echo '$$$$$$$$$$$$$$$$$$$$$$$$$$$'
        # >&2 echo "filemancmd: ${kak_filemancmd}"
        # >&2 echo "kak_buffile: $kak_buffile"
        # >&2 echo "kak_pwd: $kak_pwd"
        # >&2 echo "filename: $filename"
        # >&2 echo '$$$$$$$$$$$$$$$$$$$$$$$$$$$'
        kak_cmd="evaluate-commands -client $kak_client edit $filename"
        echo $kak_cmd | kak -p $kak_session
    } -- %opt{filemancmd} %val{buffile} %val{session} %val{client} %arg{@}
}

}

hook -once global KakBegin .* %{ require-module fileman }
