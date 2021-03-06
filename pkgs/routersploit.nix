{lib, stdenv, pkgs, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "routersploit";
  version = "3fd3946";

  src = fetchFromGitHub {
    owner = "threat9";
    repo = "routersploit";
    rev = version;
    sha256 = "0j1c6xl5nws8r81847a7jhwjc88aafkq9yby6rczym0mpnyg8i10";
  };

  #nativeBuildInputs = [ pkg-config ctags ];
  #buildInputs = [ ncurses libressl man ];
  strictDeps = true;

  meta = with lib; {
    homepage = "https://git.causal.agency/catgirl/about/";
    license = licenses.bsd3;
    description = "Exploitation framework for embedded devices";
    platforms = platforms.unix;
    maintainers = with maintainers; [ xfnw ];
  };
}
