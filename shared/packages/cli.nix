{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bear # compile-commands.json for clangd lsp
    btop
    clang-tools # we really only want clangd, the lsp
    deno # typescript language server
    editorconfig-core-c
    entr
    glances
    go
    gopls # golang LSP
    # (callPackage ../../pkgs/micasa.nix {})
    mosh
    nixd # nix lsp
    nixfmt-rfc-style
    postgres-language-server
    pyright # python typechecker and LSP
    ruff # Extremely fast Python linter and code formatter
    rust-analyzer
    rustfmt
    tmux
    # TODO: as of now, this version of ty doesn't work very well
    #   using pyright instead, at a later date we'll switch
    ty # python typechecker and LSP
    typescript-language-server
    uv # Extremely fast Python package installer and resolver, written in Rust
    zig
    zls
  ];
}
