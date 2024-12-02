# Use ripgrep instead of grep
set-option global grepcmd 'rg -Hn --no-heading'
# Display tooltip for every command in normal mode
set-option -add global autoinfo normal
set-option global spell_lang 'en_US'

# enable line numbers for normal buffers
hook global WinCreate ^[^*]+$ %{ add-highlighter buffer/ number-lines -hlcursor -cursor-separator '>' }
hook global WinCreate \*grep\* %{ add-highlighter buffer/ number-lines -hlcursor -cursor-separator '>' }
add-highlighter global/ wrap -word -indent

# Highlight all strings that match search register
set-face global CurSearch default,default,bright-green+cb
hook global RegisterModified '/' %{ add-highlighter -override global/search regex "%reg{/}" 0:CurSearch }

# Enable editor config
# ────────────────────

hook global BufOpenFile .* %{ editorconfig-load }
hook global BufNewFile .* %{ editorconfig-load }

# Switch cursor color in insert mode
# ──────────────────────────────────

set-face global InsertCursor default,green+B

hook global ModeChange .*:.*:insert %{
    set-face window PrimaryCursor InsertCursor
    set-face window PrimaryCursorEol InsertCursor
}

hook global ModeChange .*:insert:.* %{ try %{
    unset-face window PrimaryCursor
    unset-face window PrimaryCursorEol
} }

# Silly stuff

define-command -docstring 'Get weather from wttr.in' weather %{
    fifo -name *weather* %{
        trap - INT QUIT
        curl -s 'wttr.in/?T'
    }
    set-option buffer filetype weather
    set-option buffer jump_current_line 0
}

# TODO: add commands for upping/downing/redoing migration if it's current buffer
# like :ruby-alternate-file
define-command depot-reset-db -docstring 'Drop/create/seed depot databases' %{
    evaluate-commands -no-hooks %sh{
        output=$(mktemp -d "${TMPDIR:-/tmp}"/kak-rails-db-reset.XXXXXX)/fifo
        mkfifo ${output}
        (bin/rake db:drop db:create db:schema:load db:seed > ${output} 2>&1 &) > /dev/null 2>&1 < /dev/null
        (echo "######## PREPARING TEST DATABASES" > ${output} 2>&1 &) > /dev/null 2>&1 < /dev/null
        (RAILS_ENV=test bin/rake db:test:prepare db:seed > ${output} 2>&1 &) > /dev/null 2>&1 < /dev/null
        printf %s\\n "evaluate-commands %{
            edit! -fifo ${output} -scroll *depot-reset-db*
            set-option buffer filetype log
            hook -always -once buffer BufCloseFifo .* %{ nop %sh{ rm -r $(dirname ${output}) } }
        }"
    }
}
