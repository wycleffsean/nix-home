{
  config,
  pkgs,
  lib,
  ...
}:
let
  ruby = pkgs.ruby;

  # e.g. ruby 3.4 becomes 3.0
  rubyApiVersion = "${lib.versions.majorMinor ruby.version.major}.0";

  rubyRiDir = "${config.xdg.dataHome}/ruby-ri/ruby-${ruby.version}";

  rubyTools = ruby.withPackages (
    ps: with ps; [
      # bundler
      rake
      rdoc
      irb

      # LSP / formatting /linting
      ruby-lsp
      # ruby-lsp-rspec
      rubocop
      standard

      # Debugging / REPL
      debug
      pry
      pry-doc

      # Test Frameworks
      rspec
      minitest
    ]
  );
in
{
  home.packages = with pkgs; [
    rubyTools
  ];

  home.sessionVariables = {
    RI_PAGER = "less -R";

    # Writable user gem home so RubyGems doesn't try
    # writing to /nix/store
    GEM_HOME = "${config.xdg.dataHome}/gem/ruby/${rubyApiVersion}";
    GEM_SPEC_CACHE = "${config.xdg.dataHome}/gem/specs";
  };

  home.sessionPath = [
    "${config.xdg.dataHome}/gem/ruby/${rubyApiVersion}/bin"
    # TODO: probably doesn't belong with ruby.nix
    "${config.home.homeDirectory}/.local/bin"
  ];

  programs.git.ignores = [
    ".ruby-lsp/"
    ".bundle/"
  ];
}
