# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      /home/guoyi/nix/hosts.nix
      /etc/nixos/hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  #  Enable networking
  networking.networkmanager.enable = true;
  # networking.wireless.iwd.settings = {
  #   IPv6 = {
  #     Enable = true;
  #   };
  #   Settings = {
  #     AutoConnect = true;
  #   };
  # };
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
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "video" ];
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
    # ];
    enabled = "fcitx5";
    # waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk # alternatively, kdePackages.fcitx5-qt
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

  programs.npm.package = true;

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
    mako
    rofi
  ];

  # Enable the Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
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
    image = /home/guoyi/nix/pics/Desert-Background-Download-Free.jpg;
  };
  programs.hyprland = {
    enable = true;
    #   # set the flake package
    #   package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    #   # make sure to also set the portal package, so that they are in sync
    #   portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
}

