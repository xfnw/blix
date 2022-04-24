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
    
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDBUk5IjB3+trnVO6pncivFbOetUL8BPTl3CwAtk4532 xfnw@raven" ];
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
    inetutils dnsutils dnsx whois jo jq

    # network analysis
    nmap masscan wireshark wireshark-qt termshark netsniff-ng argus
    bettercap stress-ng multimon-ng aircrack-ng mfcuk pixiewps nuclei
    hcxtools dirb sslsplit whsniff sniffglue pwnat cutecom minicom
    subfinder zap hping proxychains minimodem macchanger testssl
    gnirehtet whatweb # cadaver

    # research
    theharvester tor

    # disk analysis
    testdisk squashfs-tools-ng ddrescue yara yarGen yallback
    stegseek apktool adbfs-rootless ursadb android-udev-rules
    valgrind dos2unix file exiftool foremost pngcheck ccrypt
    docker xcd trufflehog sleuthkit radare2 radare2-cutter
    clamav spyre snowman jadx ghidra # volatility

    # exploit
    doona metasploit twa wifite2 burpsuite wpscan wfuzz
    sqlmap thc-hydra (callPackage ./pkgs/routersploit.nix { })
    dsniff (callPackage ./pkgs/beef { }) dnschef

    # crack
    hashcat mfoc john crunch diceware crowbar # pyrit
    cowpatty bully deepsea reaverwps amass medusa nasty
    (callPackage ./pkgs/cupp.nix { })

    # security scan
    lynis chkrootkit aflplusplus

    # development
    arduino python3Packages.pip # ino

    # python3 packages
    python3 python3Packages.bluepy python3Packages.future
    python3Packages.requests python3Packages.paramiko python3Packages.pysnmp
    python3Packages.pycryptodome python3Packages.setuptools
    python3Packages.binwalk python3Packages.sqlmap

    # disclosure
    catgirl tmate
  ];

  environment.etc = {
    "tmux.conf" = {
      text = ''
        set-option -g default-terminal "tmux-256color"
        set-option -g history-limit 20000
        set-option -g focus-events on
        set-option -g xterm-keys on
        set-option -g set-titles on
        set-option -g set-titles-string "tmux - #T"
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
        set-option -g window-status-format          " #I #W "
        set-option -g window-status-separator       ""
        set-option -g window-status-current-format  " #I #W "
        set-option -g status-left                   ""
        set-option -g status-right                  "#h %I:%M %p"
        set-option -g status-left-length            0
        set-option -g monitor-activity on
        set-option -g visual-activity on
        set-option -g renumber-windows on
        set-option -g focus-events on
        bind N swap-window -t +1 -d
        bind P swap-window -t -1 -d
        bind S-Left swap-pane -s '{left-of}'
        bind S-Right swap-pane -s '{right-of}'
        bind S-Up swap-pane -s '{up-of}'
        bind S-Down swap-pane -s '{down-of}'
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
