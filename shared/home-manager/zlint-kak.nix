{pkgs, ...}: let
  zlintKak = pkgs.writeShellApplication {
    name = "zlint-kak";
    runtimeInputs = [
      pkgs.python3
      pkgs.zig-zlint
    ];
    text = ''
      exec ${pkgs.python3}/bin/python3 - "$@" <<'PY'
      import json
      import subprocess
      import sys

      path = sys.argv[1]

      proc = subprocess.run(
          ["zlint", "--format", "json", "--no-summary", path],
          capture_output=True,
          text=True,
      )

      for line in proc.stdout.splitlines():
          if not line.strip():
              continue

          diagnostic = json.loads(line)
          label = diagnostic["labels"][0]
          start = label["start"]

          level = diagnostic["level"]
          if level == "warn":
              level = "warning"

          message = diagnostic["message"]
          code = diagnostic.get("code")

          if code:
              message = f"{code}: {message}"

          print(
              f"{path}:{start['line']}:{start['column']}:"
              f"{level}:{message}"
          )

      # Don't make Kakoune's linting fail merely because ZLint found
      # warnings/errors. The diagnostics themselves are the output.
      sys.exit(0)
      PY
    '';
  };
in {
  home.packages = with pkgs; [
    zlintKak
  ];
}
