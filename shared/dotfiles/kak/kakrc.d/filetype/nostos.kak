# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.](no) %{
    set-option buffer filetype nostos
}

hook -group yaml-highlight global WinSetOption filetype=nostos %{
    add-highlighter window/yaml ref nostos
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/yaml }
}
