# -d
#               detail mode
# -e
#               open text files in $VISUAL (else $EDITOR, fallback vi) [preferably CLI]
# -H
#               show hidden files
# -r
#               show cp, mv progress
#               (Linux‐only, needs advcpmv; ’^T’ shows the progress on BSD/macOS)

export NNN_OPTS="deHr"
export NNN_PLUG=';:kak_open'
