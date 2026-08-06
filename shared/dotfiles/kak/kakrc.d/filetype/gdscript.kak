hook -group lsp-filetype-gdscript global BufSetOption filetype=gdscript %{

    set-option buffer tabstop 4
    set-option buffer indentwidth 0

    set-option buffer lsp_servers %|
        [gdscript]
        filetypes = ["gdscript"]
        root_globs = ["project.godot", ".git"]
        command = "godot_lsp"
    |
}
