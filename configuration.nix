# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs,  inputs, lib, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      /home/guoyi/nix/etc/hosts.nix
      /etc/nixos/hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless =
  # {
  #     enable = true;
  #     # networks."9".psk = "11111111";
  #     # extraConfig = "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel";
  #   };
  # Enables wireless support via wpa_supplicant.
  # networking.wireless.userControlled.enable = true; # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  #  Enable networking
  networking.networkmanager.enable = true;
  networking.wireless.iwd.settings = {
    IPv6 = {
      Enable = true;
    };
    Settings = {
      AutoConnect = true;
    };
  };
  # system.activationScripts = {
  #   rfkillUnblockWlan = {
  #     text = ''
  #       rfkill unblock wlan
  #     '';
  #     deps = [ ];
  #   };
  # };
  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "zh_CN.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  # Enable the X11 windowing system.

  # Enable the KDE Plasma Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11

  #   layout = "en";
  #   variant = "";
  # };
  #
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.
  # sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.guoyi = {
    isNormalUser = true;
    description = "guoyi";
    shell = pkgs.fish;
    extraGroups = [ "wheel" "networkmanager" "video" "storage" ];
    packages = with pkgs; [
    ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "guoyi";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      sarasa-gothic
      font-awesome
      wqy_microhei
      # (nerdfonts.override {
      #   fonts = [ "FiraCode" "SourceCodePro" "Hack" ];
      # })
    ];
    fontconfig = { };
  };

  i18n.inputMethod = {
    # enabled = "ibus";
    # ibus.engines = with pkgs.ibus-engines; [
    #   libpinyin
    #   ibus-tweaker
    #   ibus-engines
    # ];
    enabled = "fcitx5";
    # waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk # alternatively, kdePackages.fcitx5-qt
      rime-data
      fcitx5-chinese-addons # table input method support
      fcitx5-nord
      fcitx5-rime # a color theme
    ];
  };

  boot.supportedFilesystems = [ "ntfs" ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true;

  security.sudo.wheelNeedsPassword = false;
  users.users.guoyi.ignoreShellProgramCheck = true;
  boot.loader.systemd-boot.configurationLimit = 3;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 3d";
  };

  # jnix.settings.auto-optimise-store = true;

  # swapDevices = [{
  #   device = "/swapfile";
  #   size = 16 * 1024; # 16GB
  # }];
  # hybrid sleep when press power button
  # services.logind.extraConfig = ''
  #   HandlePowerKey=suspend
  #   IdleAction=suspend
  #   IdleActionSec=1m
  # '';

  # screen locker
  # programs.xss-lock.enable = true;

  # programs.npm.package = true;

  environment.systemPackages = with pkgs; [
    gnome3.gnome-tweaks
    # gnomeExtensions.gsconnect
    gcc
    nodejs
    wl-clipboard
    rustup
    rust-analyzer
    gnomeExtensions.dash-to-panel
    clang
    flat-remix-gnome
    android-tools
    cmake
    gnumake
    gnomeExtensions.ibus-tweaker
    grim
    slurp
    iptsd
    mako
    rofi
    go
    inputs.nixvim.packages.${system}.default
    
  ];


  # Enable the Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  services.xserver = {
    enable = true;
    #   # dpi = 180;
    #   desktopManager = {
    #     gnome.enable = true;
    #   };
  };

  # services.xserver.windowManager.dwm.enable = true;
  # services.xserver.windowManager.dwm.package = pkgs.dwm.overrideAttrs {
  #   src = /home/guoyi/nix/dwm-flexipatch;
  # };

  services.gnome.gnome-keyring.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # programs.sway = {
  #   enable = true;
  #   wrapperFeatures.gtk = true;
  # };
  programs.light.enable = true;

  #   security.polkit.enable = true;
  #   security.pam.services.swaylock = { };

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    fonts = {
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
    # image = pkgs.fetchurl {
    #    url = "https://www.pixelstalk.net/wp-content/uploads/2016/07/Desert-Background-Download-Free.jpg";
    #    # sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
    #  };
    image = /home/guoyi/nix/lib/pics/Desert-Background-Download-Free.jpg;
  };
  programs.hyprland = {
    enable = true;
    #   # set the flake package
    #   package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # package = hyprpaper;
    #   # make sure to also set the portal package, so that they are in sync
    #   portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # Disable NetworkManager's internal DNS resolution
  networking.networkmanager.dns = "none";

  # These options are unnecessary when managing DNS ourselves
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;
  # Configure DNS servers manually (this example uses Cloudflare and Google DNS)
  # IPv6 DNS servers can be used here as well.
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
    "8.8.8.8"
    "8.8.4.4"
  ];
  # programs.waybar = {
  #   enable = true;
  #   # package = inputs.hyprland.packages.${pkgs.system}.waybar-hyprland;
  # };
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
  # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
  # nix.channel.enable = true; # remove nix-channel related tools & configs, we use flakes instead.

#   services.xserver.displayManager.sessionCommands = ''
#   ${pkgs.xorg.xrdb}/bin/xrdb -merge <${pkgs.writeText "Xresources" ''
#     Xcursor.theme: Adwaita
#     Xcursor.size: 64
#

# xterm.termName: xterm-256color
# xterm.geometry: 80x36
# xterm*scrollBar: false
# xterm*rightScrollBar: true
# xterm*loginshell: true
# xterm*cursorBlink: true
# xterm*background:  black
# xterm*foreground:  gray
# xterm.borderLess: true
# xterm.cursorBlink: true
# xterm*colorUL: yellow
# xterm*colorBD: white
#
# !fix alt key input
# xterm*eightBitInput: false
# xterm*altSendsEscape: true
#
# !print color and bold/underline attributes
# xterm*printAttributes: 2
# xterm*printerCommand: cat > ~/xtermdump
#
# !mouse selecting to copy, ctrl-v to paste
# !Ctrl p to print screen content to file
# XTerm*VT100.Translations: #override \
#     Ctrl <KeyPress> V: insert-selection(CLIPBOARD,PRIMARY,CUT_BUFFER0) \n\
#     <BtnUp>: select-end(CLIPBOARD,PRIMARY,CUT_BUFFER0) \n\
#     Ctrl <KeyPress> P: print() \n
#
# !font and locale
# xterm*locale: true
# xterm.utf8:     true
# xterm*utf8Title: true
# xterm*fontMenu*fontdefault*Label: Default
# xterm*faceName: Monaco:antialias=True:pixelsize=15
# !xterm*faceName: monofur:antialias=True:pixelsize=20
# !xter*boldFont: DejaVu Sans Mono:style=Bold:pixelsize=15
# xterm*faceNameDoublesize: wenquanyi bitmap song:pixelsize=16:antialias=True
# xterm*xftAntialias: true
# xterm*cjkWidth:false
#
# !-- Tango color scheme
# *xterm*color0: #2e3436
# *xterm*color1: #cc0000
# *xterm*color2: #4e9a06
# *xterm*color3: #c4a000
# *xterm*color4: #3465a4
# *xterm*color5: #75507b
# *xterm*color6: #0b939b
# *xterm*color7: #d3d7cf
# *xterm*color8: #555753
# *xterm*color9: #ef2929
# *xterm*color10: #8ae234
# *xterm*color11: #fce94f
# *xterm*color12: #729fcf
# *xterm*color13: #ad7fa8
# *xterm*color14: #00f5e9
# *xterm*color15: #eeeeec
#
#   ''}
# '';
#   nixpkgs.overlays =
#     [ (import /home/guoyi/nix/overlay-iptsd.nix) ];
  
#   boot.kernelPatches = [{
#   name = "debug-info-config";
#   patch = null;
#   extraConfig = ''
#     DEBUG_INFO_BTF n
#   '';
# }];
 }

