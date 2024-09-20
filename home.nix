{ config, pkgs, ... }:

{

  networking.extraHosts = ''
 
151.101.42.217  cache.nixos.org
151.101.110.217  cache.nixos.org
199.232.46.217  cache.nixos.org
146.75.122.217  cache.nixos.org
151.101.78.217  cache.nixos.org

# GitHub520 Host Start
140.82.113.26                 alive.github.com
140.82.112.6                  api.github.com
185.199.111.153               assets-cdn.github.com
185.199.108.133               avatars.githubusercontent.com
185.199.108.133               avatars0.githubusercontent.com
185.199.108.133               avatars1.githubusercontent.com
185.199.108.133               avatars2.githubusercontent.com
185.199.108.133               avatars3.githubusercontent.com
185.199.109.133               avatars4.githubusercontent.com
185.199.108.133               avatars5.githubusercontent.com
185.199.108.133               camo.githubusercontent.com
140.82.114.22                 central.github.com
185.199.108.133               cloud.githubusercontent.com
140.82.113.10                 codeload.github.com
140.82.114.22                 collector.github.com
185.199.108.133               desktop.githubusercontent.com
185.199.108.133               favicons.githubusercontent.com
140.82.112.3                  gist.github.com
54.231.132.145                github-cloud.s3.amazonaws.com
52.217.133.113                github-com.s3.amazonaws.com
54.231.198.81                 github-production-release-asset-2e65be.s3.amazonaws.com
52.217.160.193                github-production-repository-file-5c1aeb.s3.amazonaws.com
52.216.171.179                github-production-user-asset-6210df.s3.amazonaws.com
192.0.66.2                    github.blog
140.82.112.3                  github.com
140.82.114.17                 github.community
185.199.109.154               github.githubassets.com
151.101.1.194                 github.global.ssl.fastly.net
185.199.108.153               github.io
185.199.108.133               github.map.fastly.net
185.199.111.153               githubstatus.com
140.82.114.25                 live.github.com
185.199.109.133               media.githubusercontent.com
185.199.108.133               objects.githubusercontent.com
13.107.43.16                  pipelines.actions.githubusercontent.com
185.199.108.133               raw.githubusercontent.com
185.199.108.133               user-images.githubusercontent.com
13.107.213.40                 vscode.dev
140.82.114.21                 education.github.com


# Update time: 2023-11-03T08:18:11+08:00
# Update url: https://raw.hellogithub.com/hosts
# Star me: https://github.com/521xueweihan/GitHub520
# GitHub520 Host End

'';
  # imports = [
  # ];
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
  home.packages = with pkgs;[
    unstable.neovim
    microsoft-edge
    zip
    xclip
    gtypist
    unzip
    dmenu
    mpv
    lazygit
  ];

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
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "gentoo";
    };
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.4.0";
          sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
        };
      }
    ];
  };

  # wayland.windowManager.sway = {
  #   enable = true;
  #   config = rec {
  #     modifier = "Mod4";
  #     # Use kitty as default terminal
  #     terminal = "kgx";
  #     startup = [
  #       # Launch Firefox on start
  #       { command = "microsoft-edge"; }
  #       { command = "kgx"; }
  #     ];
  #   };
  # };
}
