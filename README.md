# blix
blix is a nixos-based live environment with some
penetration testing tools


## building
```sh
nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=blix.nix
```

