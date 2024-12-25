{ stdenv, lib, fetchurl, undmg, unzip }:

let
  # build = "161";
in stdenv.mkDerivation {
  name = "ghostty";
  # version = "161";
  nativeBuildInputs = [ undmg unzip ];
  phases = ["unpackPhase" "installPhase"];

  sourceRoot = ".";
  src = fetchurl {
      name = "Ghostty.dmg";
      url = "https://github.com/ghostty-org/ghostty/releases/download/tip/Ghostty.dmg";
      sha256 = "ed359fbc76ca5917113dae836d2db3feeeaca0758238549380c19b95697ffee1";
  };

  installPhase = ''
    mkdir -p "$out/Applications/Ghostty.app"
    cp -pR * "$out/Applications/Ghostty.app"
  '';
  meta = with lib; {
    description = "Ghostty";
    homepage = "https://ghostty.org/";
    maintainers = [ maintainers.trickster ];
    platforms = platforms.darwin;
  };
    
}
