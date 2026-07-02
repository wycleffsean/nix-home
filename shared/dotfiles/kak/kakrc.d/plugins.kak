evaluate-commands %sh{
    plugins="$kak_config/plugins"
    mkdir -p "$plugins"
    [ ! -e "$plugins/plug.kak" ] && \
      git clone -q https://github.com/andreyorst/plug.kak.git "$plugins/plug.kak"
    printf "%s\n" "source '$plugins/plug.kak/rc/plug.kak'"
}

plug "andreyorst/plug.kak" noload
plug "andreyorst/fzf.kak" config %{
    # map -docstring 'fzf mode' global normal '<c-p>' ': fzf-mode<ret>'
} demand fzf %{
    set-option global fzf_highlight_command 'bat'
} demand fzf-file %{
    set-option global fzf_file_command 'rg'
} demand fzf-grep %{
    set-option global fzf_grep_command 'rg'
}

plug "eraserhd/kak-ansi"

plug "eburghar/kakpipe" do %{
	cargo install --force --path . --root ~/.local
}
