{lib, stdenv, pkgs, fetchFromGitHub, python3 }:

stdenv.mkDerivation rec {
  pname = "cupp";
  version = "56547fd";

  src = fetchFromGitHub {
    owner = "Mebus";
    repo = "cupp";
    rev = version;
    sha256 = "1np468jlabc6xkffbp2hdbmkhc8ln4nhfdqlh7h1c9pv1a4i8h4y";
  };

  buildInputs = [ python3 ];
  strictDeps = true;

  buildPhase = ''
    true
  '';

  installPhase = ''
    chmod 755 cupp.py
    mkdir -p $out/bin
    cp -r cupp.cfg cupp.py $out/bin
  '';

  meta = with lib; {
    homepage = "https://git.causal.agency/catgirl/about/";
    license = licenses.bsd3;
    description = "Exploitation framework for embedded devices";
    platforms = platforms.unix;
    maintainers = with maintainers; [ xfnw ];
  };
}
