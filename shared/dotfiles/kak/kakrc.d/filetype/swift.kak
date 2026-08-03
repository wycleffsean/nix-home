hook global WinSetOption filetype=swift %{
    # TODO: https://golangci-lint.run/welcome/install/#install-from-sources
    # set-option buffer lintcmd ''
    # set-option window formatcmd 'gopls format'


    # Enable Swift indentation
    set-option buffer tabstop 4
    set-option buffer shiftwidth 4
    set-option buffer expandtab 1

    # https://github.com/kakoune-lsp/kakoune-lsp?tab=readme-ov-file#semantic-tokens
    hook window -group semantic-tokens BufReload .* lsp-semantic-tokens
    hook window -group semantic-tokens NormalIdle .* lsp-semantic-tokens
    hook window -group semantic-tokens InsertIdle .* lsp-semantic-tokens
    hook -once -always window WinSetOption filetype=.* %{
        remove-hooks window semantic-tokens
    }

    # hook -once -always window WinSetOption filetype=.* %{
    #     remove-hooks window go-buffer
    # }
}

# LSP
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾


# We create an ssh tunnel to a mac host and talk
# to the lsp over that tunnel
hook -group lsp-filetype-swift global BufSetOption filetype=swift %{
    set-option buffer lsp_servers %<
        [swift]
        root_globs = [".git"]
        command = "ssh"
        # args = ["macbook-pro", "sourcekit-lsp"]
        # args = [
        #     "macbook-pro", # host in ~/.ssh/config
        #     "sourcekit-lsp",
        #     "--default-workspace-type",
        #     "buildServer",
        #     "-index-prefix-map",
    	   #  "/foxcroft/code=/Volumes/foxcroft/code",
        # ]

        args = [
          "macbook-pro",
          "bash", "-lc",
          "cd /Volumes/foxcroft/code/Maki && exec sourcekit-lsp --default-workspace-type buildServer --experimental-feature structured-logs"
        ]
        settings_section = "sourcekit-lsp"
        [swift.settings.sourcekit-lsp]
        # Code lens (shows test runners, references, etc.)
        codeLensProvider = true
        inlayHintProvider = true
    >
}
