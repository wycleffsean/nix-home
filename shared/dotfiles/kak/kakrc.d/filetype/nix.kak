# Copied from the zig.kak file

hook global WinSetOption filetype=nix %{
    set-option buffer formatcmd 'nixfmt -'
    # set-option global lsp_server_configuration zls.zig_lib_path="/usr/lib/zig"
    # set-option -add global lsp_server_configuration zls.warn_style=true
    # set-option -add global lsp_server_configuration zls.enable_semantic_tokens=true

    # https://github.com/kakoune-lsp/kakoune-lsp?tab=readme-ov-file#semantic-tokens
    hook window -group semantic-tokens BufReload .* lsp-semantic-tokens
    hook window -group semantic-tokens NormalIdle .* lsp-semantic-tokens
    hook window -group semantic-tokens InsertIdle .* lsp-semantic-tokens
    hook -once -always window WinSetOption filetype=.* %{
        remove-hooks window semantic-tokens
    }
}

hook global BufSetOption filetype=nix %{
    # set-option buffer lintcmd 'zig fmt --color off --ast-check 2>&1'
    # To enable auto linting on buffer write
    #hook -group zig-auto-lint buffer BufWritePre .* lint-buffer
    # hook -group zig-auto-lint buffer BufWritePre .* lsp-formatting-sync
}
# LSP
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾


# We create an ssh tunnel to a mac host and talk
# to the lsp over that tunnel
hook -group lsp-filetype-nix global BufSetOption filetype=nix %{
    set-option buffer lsp_servers %|
        [nixd]
        root_globs = ["flake.nix", "shell.nix", ".git"]
        settings_section = "nixd"

        [nixd.settings.nixd]

        # see this blog for details on nixd setup
        # https://sbulav.github.io/vim/neovim-setting-up-nixd/

        # Use the nixpkgs input belonging to the current project flake
        # Fall back to NIX_PATH for unusual flakes without inputs.nixpkgs
        # nixpkgs.expr = "let flake = builtins.getFlake (builtins.toString ./.); in if flake ? inputs && flake.inputs ? nixpkgs then
        nixpkgs.expr = "let flake = builtins.getFlake (builtins.toString ./.); in if flake ? inputs && flake.inputs ? nixpkgs then import flake.inputs.nixpkgs { } else import <nixpkgs> { }"

        formatting.command = ["nixfmt"]

        # Full NixOS option completion for our nix-home repo
        # In unrelated flakes, produce an empty option string instead of failing
        options.nixos.expr = "let flake = builtins.getFlake (builtins.toString ./.); in if flake ? nixosConfigurations && flake.nixosConfigurations ? nixos then flake.nixosConfigurations.nixos.options else { }"

        # we integrate home manager too
        # we don't ever call "home-manager switch --flake ...", we use nixos-rebuild
        # or darwin-rebuild so this expression is more appropriate
        options.home-manager.expr = "let flake = builtins.getFlake (builtins.toString ./.); in if flake ? nixosConfigurations && flake.nixosConfigurations ? nixos then flake.nixosConfigurations.nixos.options.home-manager.users.type.getSubOptions [] else { }"
    |
}
