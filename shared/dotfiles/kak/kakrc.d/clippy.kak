provide-module clippy %{

# https://github.com/mawww/kakoune/pull/3385
# delay in ms before clippy appears when moving
# this option was removed apparently
# set-option global next_key_idle_timeout 500

define-command clippy -params 1 -docstring 'Configure terminal assistant' %{
    set-option global ui_options "terminal_assistant=%arg{1}"
}

complete-command -menu clippy shell-script-candidates %{
    printf %s\\n \
    	clippy \
    	cat \
    	dilbert \
    	none \
    	off \
    ;
}

}

hook -once global KakBegin .* %{ require-module clippy }
