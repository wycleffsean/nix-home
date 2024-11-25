# Install

On a fresh NixOS install

```
$ nixos-install --flake github:wycleffsean/nix-home
```

# Update

```
$ nixos-rebuild switch --flake github:wycleffsean/nix-home
```

# Help with home-manager

```
man home-configuration.nix
```

## Installing flakes from private repos

Some repos e.g. github.com/ghostty-org/ghostty (as of today) require ssh auth and
the build will fail if you don't pass valid ssh config.  You can solve this with
`NIX_SSHOPTS`:

```
NIX_SSHOPTS="-F ${HOME}/.ssh/config" sudo nixos-rebuild switch --flake .
```

This should only be necessary the first time to build the cache
