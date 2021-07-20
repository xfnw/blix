# This module defines a small blix live enviorment

{config, pkgs, lib, ...}:

with lib;
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/iso-image.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>

    <nixpkgs/nixos/modules/profiles/clone-config.nix>
    <nixpkgs/nixos/modules/profiles/all-hardware.nix>
    <nixpkgs/nixos/modules/profiles/base.nix>
  ];
  
  # ISO naming.
  isoImage.isoName = "blix-${config.system.nixos.label}-${pkgs.stdenv.system}.iso";

  isoImage.volumeID = substring 0 11 "BLIX_ISO";

  # EFI booting
  isoImage.makeEfiBootable = true;

  # USB booting
  isoImage.makeUsbBootable = true;

  # Add Memtest86+ to the CD.
  boot.loader.grub.memtest86.enable = true;
 
  networking.hostName = "blix";
  networking.wireless.enable = true;
  networking.useDHCP = true;

  i18n.defaultLocale = "en_US.UTF-8";
  

  documentation.nixos.enable = true;

  services.getty.autologinUser = "fops";

  users.users.fops = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "libvirt" "docker" ];
    
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1N
TE5AAAAIDBUk5IjB3+trnVO6pncivFbOetUL8BPTl3CwAtk4532 xfnw@raven" ];
  };
  security.sudo.wheelNeedsPassword = false;

  services.xserver.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "fops";



  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    (callPackage ./manuals.nix { })

    wget vim tmux gnupg ncdu mosh
    git curl rsync wireguard-tools
    w3m lynx elinks ungoogled-chromium
    inetutils dnsutils dnsx whois

    # network analysis
    nmap masscan wireshark termshark netsniff-ng argus bettercap
    stress-ng multimon-ng aircrack-ng mfcuk pixiewps
    hcxtools dirb sslsplit whsniff sniffglue pwnat
    subfinder zap hping proxychains minimodem
    gnirehtet # reverse android tethering

    # research
    theharvester tor

    # disk analysis
    testdisk squashfs-tools-ng ddrescue volatility
    stegseek apktool adbfs-rootless ursadb android-udev-rules
    valgrind dos2unix file exiftool foremost pngcheck
    docker xcd

    # exploit
    doona metasploit twa wifite2 burpsuite wpscan wfuzz
    sqlmap thc-hydra (callPackage ./pkgs/routersploit.nix { })
    dsniff 

    # crack
    hashcat mfoc pyrit john crunch diceware crowbar
    cowpatty bully deepsea reaverwps amass medusa
    (callPackage ./pkgs/cupp.nix { })

    # security scan
    lynis chkrootkit

    # development
    arduino python3Packages.pip ino

    # python3 packages
    python3 python3Packages.bluepy python3Packages.future
    python3Packages.requests python3Packages.paramiko python3Packages.pysnmp
    python3Packages.pycryptodome python3Packages.setuptools
    python3Packages.binwalk

    # disclosure
    catgirl tmate
  ];

  environment.etc = {
    "tmux.conf" = {
      text = ''
        set-option -g default-terminal "tmux-256color"
        set-option -g mouse on
        set-option -g history-limit 20000
        set-option -g focus-events on
        set-option -g xterm-keys on
        set-option -g set-titles on
        set-option -g set-titles-string "tmux - #t"
        set-option -g escape-time 25
        set-option -g status-left-style             "fg=colour10"
        set-option -g status-right-style            "fg=colour10"
        set-option -g status-style                  "bg=default,fg=colour10"
        set-option -g pane-active-border-style      "bg=default,fg=colour10"
        set-option -g window-status-activity-style  "bg=default,fg=colour235,bold,reverse"
        set-option -g window-status-bell-style      "bg=default,fg=white,bold,reverse"
        set-option -g window-status-current-style   "bg=default,fg=colour10,bold,reverse"
        set-option -g window-status-style           "bg=default,fg=colour10"
        set-option -g status on
        set-option -g status-interval 5
        set-option -g status-position top
        set-option -g status-justify left
        set-option -g window-status-format          " #i #w "
        set-option -g window-status-separator       ""
        set-option -g window-status-current-format  " #i #w "
        set-option -g status-left                   ""
        set-option -g status-right                  "#h %i:%m %p"
        set-option -g status-left-length            0
        set-option -g monitor-activity on
        set-option -g visual-activity on
        set-option -g renumber-windows on
        set-option -g focus-events on
      '';
    };
    "vimrc" = {
      text = ''
        set number
        set relativenumber
        syntax on
        color pablo
        set nocompatible
        filetype plugin indent on
        set showcmd
        set showmatch
        set ignorecase
        set smartcase
        set incsearch
        set autowrite
        set hidden
        set mouse=a
        set textwidth=60
        set formatoptions-=t
      '';
    };
  };

  environment.variables.GC_INITIAL_HEAP_SIZE = "1M";
  boot.kernel.sysctl."vm.overcommit_memory" = "1";
  boot.consoleLogLevel = 7;
  networking.firewall.logRefusedConnections = false;
  system.extraDependencies = with pkgs; [ stdenv stdenvNoCC busybox jq ];

  services.openssh.enable = true;
}
