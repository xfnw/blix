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

  propagatedBuildInputs = with pkgs.python3Packages; [
    pkgs.python3 bluepy future requests paramiko pysnmp pycryptodome setuptools
  ];

  buildPhase = ''
    true
  '';

  installPhase = ''
    chmod 755 rsf.py
    mkdir -p $out/bin
    cp -r routersploit rsf.py $out/bin
  '';

  meta = with lib; {
    homepage = "https://git.causal.agency/catgirl/about/";
    license = licenses.bsd3;
    description = "Exploitation framework for embedded devices";
    platforms = platforms.unix;
    maintainers = with maintainers; [ xfnw ];
  };
}
