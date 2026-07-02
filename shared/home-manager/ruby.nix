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
  ];

  programs.git.ignores = [
    ".ruby-lsp/"
    ".bundle/"
  ];

  home.file = {
    ".local/bin/ruby-ri-bootstrap" = {
      executable = true;
      text = ''
        #!${pkgs.bash}/bin/bash
        set -euo pipefail

        ruby_version="$(${ruby}/bin/ruby -e 'print RUBY_VERSION')"
        base="''${XDG_DATA_HOME:-$HOME/.local/share}/ruby-ri"
        out="$base/ruby-$ruby_version"
        stamp="$out/.complete"

        if [ -f "$stamp" ]; then
          echo "Ruby RI docs already exist: $out"
          exit 0
        fi

        rm -rf "$out"
        mkdir -p "$base"

        work="$(${pkgs.coreutils}/bin/mktemp -d)"
        trap 'rm -rf "$work"' EXIT

        src="${ruby.src}"

        if [ -d "$src" ]; then
          cp -R "$src" "$work/ruby-src"
          ruby_src="$work/ruby-src"
        else
          ${pkgs.gnutar}/bin/tar -xf "$src" -C "$work"
          ruby_src="$(${pkgs.findutils}/bin/find "$work" -maxdepth 1 -type d -name 'ruby-*' | ${pkgs.coreutils}/bin/head -n1)"
        fi

        tmpout="$work/ri-out"

        # Do not pre-create "$tmpout"; RDoc refuses an existing non-RDoc output dir.
        echo "Generating RI docs from $ruby_src"
        ${ruby}/bin/rdoc --ri --op "$tmpout" "$ruby_src" >/dev/null

        touch "$tmpout/.complete"
        mv "$tmpout" "$out"

        echo "Generated RI docs in $out"
      '';
    };

    ".local/bin/rbdoc" = {
      executable = true;
      text = ''
        #!${pkgs.bash}/bin/bash
        set -euo pipefail

        ruby_version="$(${ruby}/bin/ruby -e 'print RUBY_VERSION')"
        docdir="''${XDG_DATA_HOME:-$HOME/.local/share}/ruby-ri/ruby-$ruby_version"

        if [ ! -f "$docdir/.complete" ]; then
          ruby-ri-bootstrap
        fi

        if [ "''${1:-}" = "--list" ]; then
          DOCDIR="$docdir" ${ruby}/bin/ruby -ruri -e '
            docdir = ENV.fetch("DOCDIR")
            Dir.glob("#{docdir}/**/*.ri").each do |path|
              rel = path.delete_prefix("#{docdir}/")
              dir = File.dirname(rel)
              klass = dir.split("/").join("::")
              file = File.basename(rel, ".ri")

              if file.start_with?("cdesc-")
                puts klass
              elsif file =~ /\A(.+)-([ic])\z/
                method = URI.decode_www_form_component($1)
                separator = $2 == "i" ? "#" : "."
                puts "#{klass}#{separator}#{method}"
              end
            end
          ' | ${pkgs.coreutils}/bin/sort -u
          exit 0
        fi

        if [ "$#" -eq 0 ]; then
          ${ruby}/bin/ri --doc-dir "$docdir" --list \
            | ${pkgs.fzf}/bin/fzf \
            | xargs -r ${ruby}/bin/ri --doc-dir "$docdir" -T --format=ansi
        else
          ${ruby}/bin/ri --doc-dir "$docdir" -T --format=ansi "$@"
        fi
      '';
    };
  };

}
