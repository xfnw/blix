{ stdenv, man }:

stdenv.mkDerivation rec {
  name = "blix-manuals";
  src = ./manuals;

  buildInputs = [ man ];

  installPhase = ''
    install -D * -t $out/share/man/man7/
  '';
}
