provide-module clippy %{

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
