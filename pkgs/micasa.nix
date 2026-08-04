{
  pkgs,
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "micasa";
  # git ls-remote --tags https://github.com/cpcloud/micasa
  version = "1.36.1";

  src = fetchFromGitHub {
    owner = "cpcloud";
    repo = "micasa";
    rev = "ddcf871cbace55963a3e57d441b7603fe5ad8025";
    hash = "sha256-juFKOOMb2NscOnRW4dha1ni16DyCK7zfxpyeQ9qXEsw=";
  };

  go = pkgs.go_1_24;
  env.GOAMD64 = "v1";

  vendorHash = "sha256-FZfMwtcVOZ8mkA1NHXitqwp5X/FTb1VxyKvoy5qEoPU=";
  subPackages = ["cmd/micasa"];

  meta = with lib; {
    description = "Micasa CLI";
    homepage = "https://github.com/cpcloud/micasa";
    license = licenses.mit;
  };
}
