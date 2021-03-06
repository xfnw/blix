
{lib, stdenv, fetchurl, ncurses, libressl, man, pkg-config, ctags}:

stdenv.mkDerivation rec {
  pname = "catgirl";
  version = "1.6";

  src = fetchurl {
    url = "https://git.causal.agency/catgirl/snapshot/${pname}-${version}.tar.gz";
    sha256 = "0shg02zidqqmvywqqsaazlgg9rd5lhhrvjx6n0lzmdfaawxywciv";
  };

  nativeBuildInputs = [ pkg-config ctags ];
  buildInputs = [ ncurses libressl man ];
  strictDeps = true;

  meta = with lib; {
    homepage = "https://git.causal.agency/catgirl/about/";
    license = licenses.gpl3Plus;
    description = "A TLS-only terminal IRC client";
    platforms = platforms.unix;
    maintainers = with maintainers; [ xfnw ];
  };
}


