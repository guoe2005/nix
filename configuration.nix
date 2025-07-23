{ config, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ./hosts.nix ];

  # Boot Configuration
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 3; # Reduce boot menu timeout
    };
    kernelParams = [ "quiet" ]; # Quieter boot
    tmp.cleanOnBoot = true;
  };

  # Network Configuration
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 53317 8384 2200 ]; # LocalSend
      allowedUDPPorts = [ 53317 22000 2102 ]; # LocalSend
    };
  };

  # networking.wireless = {
  #   enable = true;
  #   networks."Redmi_142A".psk = "6ypcla2p";
  # };
  hardware.enableRedistributableFirmware = true;
  hardware.firmware = with pkgs; [ wireless-regdb linux-firmware ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true; # 开机自动开启蓝牙
  };

  # 确保蓝牙守护进程运行
  # services.blueman.enable = true;

  # Internationalization
  time.timeZone = "Asia/Shanghai";
  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [ fcitx5-chinese-addons ];
    };
    extraLocaleSettings = {
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
  };

  # Sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  services.xserver = {
    enable = true;
    desktopManager.cinnamon.enable = true;
    displayManager.lightdm.enable = true; # 默认显示管理器
  };

  # User Configuration
  users.users.guoyi = {
    isNormalUser = true;
    description = "guoyi";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "storage" "lp" ];
    shell = pkgs.zsh; # Consider using zsh with oh-my-zsh
    packages = with pkgs; [ git vim wget curl htop ];
  };

  # System Packages
  environment.systemPackages = with pkgs; [
    firefox
    google-chrome
    neofetch
    file
    pciutils # lspci
    usbutils # lsusb
    gvfs
    ntfs3g
    emacs
    bluez
    bluez-tools
    nemo
    # 常用语言服务器
    nil # Nix LSP
    rust-analyzer
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    haskell-language-server
    python3Packages.python-lsp-server
    clang-tools # C/C++ LSP
    gopls
    terraform-ls
    nil
    alejandra
    black # python
    nixfmt-classic
    gammastep
    sqlite

    nnn
    ueberzug # 图片预览支持
    bat # 语法高亮预览
    ffmpegthumbnailer # 视频缩略图
    poppler_utils # pdf预览
    mediainfo # 多媒体信息

    # --- 强烈推荐同时安装以下工具，它们能极大地增强 nnn 的体验： ---
    fzf # 用于 nnn 的模糊查找 (例如，按 'd' 进入目录选择模式)
    # chafa             # 将图片转换为 ASCII 艺术或 Unicode 字符画，用于在终端中预览图片
    trash-cli # 移动文件到回收站而不是直接删除
    fd # 更好的 find 命令
    ripgrep # 更好的 grep 命令
    # xsel              # 或 xclip，用于复制粘贴到系统剪贴板 (X11)
    # highlight         # 另一个代码高亮工具
    exiftool # 图片和视频的 EXIF 元数据查看
  ];

  services.flatpak.enable = true;

  # Optional: if you want to install Flatpaks for all users
  # environment.systemPackages = [ pkgs.flatpak ];

  # Programs
  programs = {
    firefox.enable = true;
    zsh.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    hyprland = {
      enable = true;
      xwayland.enable = true; # 必须启用 XWayland 支持
    };
  };

  # Nix Settings
  nix = {
    # package = pkgs.nixVersions.stable;
    #  extraOptions = "experimental-features = nix-command flakes";
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 3d";
    };
    settings.auto-optimise-store = true;
  };

  # System Services
  services = {
    openssh.enable = true;
    fstrim.enable = true; # For SSDs
    upower.enable = true; # Power management
  };

  system.stateVersion = "24.05"; # Should match your installed version

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    # Other nix settings...
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # 支持 Wayland 的 Electron 应用
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";

    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus"; # 某些应用需要这个
    INPUT_METHOD = "fcitx";
    IMSETTINGS_MODULE = "fcitx";

    # Emacs 特定设置
    EMACS_USE_EGL = "1";
    EMACSDIR = "$HOME/.config/emacs";

  };

  security.sudo.extraRules = [{
    users = [ "guoyi" ]; # 替换为你的用户名
    commands = [{
      command = "ALL"; # 允许所有命令
      options = [ "NOPASSWD" ]; # 免密码
    }];
  }];

  # 系统级电源管理
  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "powersave";

  nix.optimise.automatic = true;

  # 必需服务
  services.udisks2.enable = true;
  security.polkit.enable = true;

  # 允许普通用户挂载指定设备
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
    if (
    action.id == "org.freedesktop.udisks2.filesystem-mount-system" &&
    subject.isInGroup("storage")
    ) {
    return polkit.Result.YES;
    }
    });
  '';

  fileSystems."/mnt/D" = {
    device = "/dev/disk/by-uuid/658C81450BDCF8C2";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "umask=022"
      "nofail" # 忽略启动错误
    ];
  };

  fileSystems."/mnt/E" = {
    device = "/dev/disk/by-uuid/0280B9837C42929B";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "umask=022"
      "nofail" # 忽略启动错误
    ];
  };
  hardware.graphics.enable = true;
  services.geoclue2 = {
    enable = true;
    # 允许 redshift/gammastep 访问位置
    appConfig."gammastep" = {
      isAllowed = true;
      isSystem = false;
      users = [ "guoyi" ];
    };
  };

  # Printing
  # services.printing = {
  #   enable = true;
  #   drivers = [ pkgs.gutenprint ];
  # };

  services.printing = {
    enable = true;
    drivers = [ pkgs.cnijfilter2 ];
  }; # Canon 官方驱动
  services.avahi = {
    enable = true;
    nssmdns4 = true; # 支持网络发现
  };

  # 启用 Syncthing 服务
  services.syncthing = {
    enable = true;
    user = "guoyi"; # 替换为你的用户名
    dataDir = "/home/guoyi/Sync"; # 同步目录（可选自定义）
    # configDir = "/home/.config/syncthing"; # 配置文件目录
  };

}
