{ system ? builtins.currentSystem }:

let nixos = import "${fetchTarball {
    url = "https://releases.nixos.org/nixos/unstable/nixos-26.11pre1055335.e5bdc4a41d4c/nixexprs.tar.zst";
    sha256 = "sha256-kSR/jfpR4cE26YRZ8exQkoRbEA30vyWimajwZANYYaE=";
  }}/nixos" {
    inherit system;
    configuration = ./blix.nix;
  };
in {
  blix = nixos;
  iso = nixos.config.system.build.isoImage;
}
