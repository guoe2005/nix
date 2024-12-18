{ config, pkgs, inputs,lib, ... }:
{
  imports = [
  ];
  # 注意修改这里的用户名与用户目录
  home.username = "guoyi";
  home.homeDirectory = "/home/guoyi";

  # 直接将当前文件夹的配置文件，链接到 Home 目录下的指定位置
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # 递归将某个文件夹中的文件，链接到 Home 目录下的指定位置
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # 递归整个文件夹
  #   executable = true;  # 将其中所有文件添加「执行」权限
  # };

  # 直接以 text 的方式，在 nix 配置文件中硬编码文件内容
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # git 相关配置
  programs.git = {
    enable = true;
    userName = "guoe2005";
    userEmail = "guoe2005@126.com";
    extraConfig = {
      credential.helper = "${
      pkgs.git.override { withLibsecret = true; }
    }/bin/git-credential-libsecret";
      push = { autoSetupRemote = true; };
    };
  };

  # 通过 home.packages 安装一些常用的软件
  # 这些软件将仅在当前用户下可用，不会影响系统级别的配置
  # 建议将所有 GUI 软件，以及与 OS 关系不大的 CLI 软件，都通过 home.packages 安装
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Enable zsh
  # programs.zsh = {
  #   enable = true;
  #   oh-my-zsh = {
  #     enable = true;
  #     theme = "gentoo";
  #   };
  #   plugins = [
  #     {
  #       name = "zsh-autosuggestions";
  #       src = pkgs.fetchFromGitHub {
  #         owner = "zsh-users";
  #         repo = "zsh-autosuggestions";
  #         rev = "v0.4.0";
  #         sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
  #       };
  #     }
  #   ];
  # };
  #
  programs.kitty = lib.mkForce {
    enable = true;
    settings = {
      # font ="Hack Nerd Font";
      font_size = 12;
      confirm_os_window_close = 0;
      dynamic_background_opacity = false;
      enable_audio_bell = false;
      mouse_hide_wait = "-1.0";
      window_padding_width = 3;
      background_opacity = "0.9";
      background_blur = 5;
      # symbol_map =
        # let
          # mappings = [
            # "U+23FB-U+23FE"
            # "U+2B58"
            # "U+E200-U+E2A9"
            # "U+E0A0-U+E0A3"
            # "U+E0B0-U+E0BF"
            # "U+E0C0-U+E0C8"
            # "U+E0CC-U+E0CF"
            # "U+E0D0-U+E0D2"
            # "U+E0D4"
            # "U+E700-U+E7C5"
            # "U+F000-U+F2E0"
            # "U+2665"
            # "U+26A1"
            # "U+F400-U+F4A8"
            # "U+F67C"
            # "U+E000-U+E00A"
            # "U+F300-U+F313"
            # "U+E5FA-U+E62B"
    #       ];
    #     in
    #       (builtins.concatStringsSep "," mappings) + " Symbols Nerd Font";
    };
  };

  # stylix.targets.swaylock.useImage = true;
  # home.file.".config/sway/config".source = ./sway/config;
  # home.file.".i3/config".source = ./sway/i3/config;
  home.file.".config/hypr/hyprland.conf".source = ./config/hypr/hyprland.conf;
  home.file.".config/waybar/style.css".source = ./config/waybar/style.css;
  home.file.".config/waybar/config".source = ./config/waybar/config;
  # home.file.".config/nvim".source = ./nvim;
  # home.file.".config/mako/config".source = ./config/mako/config;
  # home.file.".config/tofi/config".source = ./config/tofi/config;
  home.file.".config/wofi/config".source = ./config/wofi/config;
  home.file.".config/wofi/style.css".source = ./config/wofi/style.css;
  home.file.".config/alacritty/alacritty.toml".source = ./config/alacritty/alacritty.toml;
  home.file.".config/fcitx5/conf/classicui.conf".source = ./config/fcitx5/conf/classicui.conf;
  # home.file.".zshrc".source = ./config/zshrc;
  home.file.".config/fish/functions/functions.fish".source = ./config/fish/functions.fish;
  home.packages = with pkgs;
    [
      (nerdfonts.override {
        fonts = [ "NerdFontsSymbolsOnly" ];
      })
    ];
  # programs.fish={
  #   enable=true;
  # };
services.kdeconnect.enable=true;
  }
