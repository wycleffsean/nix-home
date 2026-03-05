# # remove default kakoune-lsp server settings
# remove-hooks global lsp-filetype-javascript

# hook -group lsp-filetype-javascript global BufSetOption filetype=(?:javascript|typescript) %(
#     set-option buffer lsp_servers %<
#         [typescript-language-server]
#         root_globs = ["package.json", "tsconfig.json", "jsconfig.json", ".git", ".hg"]
#         args = ["--stdio"]
#         settings_section = "_"


#         [eslint-language-server]
#         command = "vscode-eslint-language-server"
#         args = ["--stdio"]
#         root_globs = ["eslint.config.mjs", "eslint.config.js", "eslint.config.cjs", ".git"]
#         workaround_eslint = true

#         [eslint-language-server.settings]
#         validate = "on"
#         run = "onType"
#         quiet = false
#         rulesCustomizations = []
#         nodePath = ""
#         problems = { shortenToSingleLine = false }

#         # CRITICAL for eslint.config.* (flat config)
#         experimental = { useFlatConfig = true }

#         # CRITICAL to make “path” resolvable / stable in many clients
#         workingDirectory = { mode = "location" }

#         # optional but commonly expected
#         codeAction = {
#           disableRuleComment = { enable = true, location = "separateLine" },
#           showDocumentation = { enable = true }
#         }
#         # optional, but fine:
#         packageManager = "bun"
#     >
# )


# remove default kakoune-lsp server settings
remove-hooks global lsp-filetype-javascript

hook -group lsp-filetype-javascript global BufSetOption filetype=(?:javascript|typescript) %{
    set-option buffer lsp_servers %<
        [typescript-language-server]
        root_globs = ["package.json", "tsconfig.json", "jsconfig.json", ".git", ".hg"]
        args = ["--stdio"]
        settings_section = "_"

        [eslint-language-server]
        command = "vscode-eslint-language-server"
        args = ["--stdio"]
        root_globs = ["eslint.config.mjs", "eslint.config.js", "eslint.config.cjs", ".git"]
        workaround_eslint = true

        [eslint-language-server.settings]
        validate = "on"
        run = "onType"
        quiet = false
        rulesCustomizations = []
        nodePath = ""
        packageManager = "bun"

        # keep these objects on ONE LINE
        problems = { shortenToSingleLine = false }
        experimental = { useFlatConfig = true }
        workingDirectory = { mode = "location" }
        codeAction = { disableRuleComment = { enable = true, location = "separateLine" }, showDocumentation = { enable = true } }
    >
}
