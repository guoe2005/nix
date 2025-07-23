{ config, pkgs, inputs, ... }:

let
  dotfilesDir =
    "${config.home.homeDirectory}/.dotfiles"; # Path to your dotfiles repo

  # Helper function to create recursive symlinks
  mkSymlink = path: {
    source = "${dotfilesDir}/${path}";
    recursive = true;
  };

  # Files that should be executable
  executableFiles = [ "scripts/backup.sh" "bin/git-sync" ];

in {
  imports = [ inputs.nixvim.homeManagerModules.nixvim ]; # 需提前将 inputs 注入
  # Basic home-manager configuration
  home.username = "guoyi";
  home.homeDirectory = "/home/guoyi";
  home.stateVersion = "24.05"; # Should match your system stateVersion

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # 启用 GTK 支持
  # gtk = {
  #   enable = true;
  #   font = {
  #     name = "Noto Sans 10";
  #     size = 10;
  #   };
  # };

  home.packages = with pkgs; [
    # Utilities
    htop
    ripgrep
    fzf
    eza
    bat
    fd
    # Development tools
    # git
    gh
    #neovim
    #vscode
    # Media
    feh
    # mpv
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    sarasa-gothic
    wqy_microhei
    waybar
    rofi-wayland
    swaybg
    swaylock
    wl-clipboard
    grim # 截图
    slurp # 区域选择
    mako # 通知
    kitty # 终端
    kanshi
    wdisplays
    xclip
    cliphist
    nixpkgs-fmt
    swayidle # 空闲管理
    wlogout # 电源菜单
    tlp # 笔记本电源优化
    brightnessctl
    font-awesome
    localsend
    zathura
    papirus-icon-theme
    android-tools
    gcc
    gnumake
    cmake
    automake
    autoconf
    kitty-themes
    imagemagick
  ];

  services.emacs = {
    enable = true;
    # 服务配置
    client.enable = true; # 启用emacsclient
  };

  programs.ssh = { enable = true; };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs30;
    extraPackages = epkgs:
      with epkgs; [
        use-package
        magit # 安装 MELPA 包
        org-roam
        gruvbox-theme # 安装 gruvbox 主题
        doom-themes
        highlight-thing

        lsp-mode
        yasnippet
        lsp-treemacs
        projectile
        hydra
        flycheck
        company
        avy
        which-key
        helm-xref
        dap-mode
        helm
        helm-lsp # LSP 集成
        helm-projectile # Projectile 集成
        helm-ag # Silver Searcher 集成
        helm-rg # Ripgrep 集成
        helm-descbinds # 查看键绑定

        nix-mode
        format-all
        quickrun
        consult
        embark
        prescient

        emacs
        pyim # 输入法框架
        pyim-basedict # 基础词库
        pyim-wbdict # 五笔词库
        posframe # 候选词悬浮窗

        vertico
        orderless
        org-download
        org
        org-super-agenda
        ox-hugo
      ];
    extraConfig = ''
       ;;-*- lexical-binding: t; -*-

      (load-theme 'gruvbox-dark-soft t)

      (add-hook 'emacs-lisp-mode-hook
              (lambda ()
                (local-set-key (kbd "M-;") 'comment-dwim)))

       (setq auto-save-default nil) ;不生成那个讨厌的##文件
      (setq backup-by-copying nil) ;不生成那个讨厌的~文件

      (use-package pyim
      :ensure nil ; 已通过 Nix 安装，无需再次下载
      :config
      ;; 设置默认输入法为 pyim
      (setq default-input-method "pyim")

      ;; 使用五笔86版
      (setq pyim-default-scheme 'wubi)

      ;; 加载五笔词库
      (use-package pyim-wbdict
      :ensure nil
      :config
      (pyim-wbdict-v86-enable)) ; 启用86版五笔

      ;; 使用 posframe 显示候选词
      (setq pyim-page-tooltip 'posframe)

      ;; 确保 pyim 已正确加载
      (with-eval-after-load 'pyim
      (defun pyim-toggle-input-method ()
      "Toggle pyim input method."
      (interactive)
      (if (string= current-input-method "pyim")
        (deactivate-input-method)
      (activate-input-method 'pyim))))

      ;; 设置切换快捷键
      (global-set-key (kbd "C-\\") 'pyim-toggle-input-method))

      ;; 中文模式下优化行为
      (add-hook 'input-method-activate-hook
          (lambda () (setq-local company-transformers nil)))

       ;; Org Mode 基础配置
       (require 'org)
       (setq org-directory "~/org")
       (setq org-agenda-files '("~/org"))

       ;; 快捷键绑定
       (global-set-key (kbd "C-c a") 'org-agenda)
       (global-set-key (kbd "C-c c") 'org-capture)

       (use-package org-roam
       :ensure t
       :after org
       :init
       (setq org-roam-v2-ack t)  ; 如果使用 org-roam v2
       :custom
       (org-roam-directory "~/org/roam")  ; 设置你的笔记目录
       (org-roam-dailies-directory "daily/")  ; 可选：将日记放在子目录下
       (org-roam-completion-everywhere t)  ; 在任何地方都能触发补全

       :bind (("C-c n f" . org-roam-node-find)  ; 手动绑定常用命令
              ("C-c n j" . org-roam-dailies-capture-today)
              ("C-c n i" . org-roam-node-insert))  ; 绑定插入链接快捷键
       :config
       (org-roam-db-autosync-mode t)
       (org-roam-setup)  ; 启用所有功能（包括 dailies）
       )

       (setq org-roam-title-sources '(title))

       (setq org-roam-dailies-capture-templates
       '(("d" "日记" entry "* %?"
       :target (file+head "%<%Y-%m-%d>.org"
       "#+TITLE: %<%Y-%m-%d>\n\n* 任务\n\n* 笔记\n\n")
       :jump-to-captured t)))

       (defun org-roam-weekly-review ()
       "生成本周回顾文档。"
       (interactive)
       (let ((filename (format-time-string "weekly-review-%Y-%m-%d.org")))
       (org-roam-capture-
       :node (org-roam-node-create)
       :templates '(("w" "weekly" plain "* 本周回顾\n%?"
                    :target (file+head "%<%Y-%m-%d>.org"
                                       "#+TITLE: 本周回顾-%<%Y-%m-%d>\n\n"))))))

       (use-package vertico  ; 垂直补全框架
       :ensure t
       :init (vertico-mode))

       (use-package orderless  ; 模糊匹配
       :ensure t
       :custom
       (completion-styles '(orderless)))

       (setq org-roam-node-display-template
       "${"title:*"} ${"tags:10"}")  ; 补全时显示标题和标签
       (setq org-roam-completion-ignore-case t)  ; 忽略大小写

       (use-package org-download
       :ensure t
       :config
       (setq org-download-image-dir "~/org/roam/images")  ; 指定图片目录
       (setq org-download-method 'directory)          ; 按目录存储
       (add-hook 'org-mode-hook 'org-download-enable))


       (setq org-display-inline-images t)  ; 启用内联显示


       (use-package recentf
       :ensure nil
       :config
       (setq recentf-save-file (concat user-emacs-directory ".recentf"))
       (setq recentf-max-saved-items 50)
       (setq recentf-max-menu-items 15)
       (recentf-mode 1))

       (global-set-key (kbd "C-x C-r") 'recentf-open-files)



       (use-package consult
       :bind
       (("C-x b" . consult-buffer)        ; 增强缓冲区历史
       ("M-s" . consult-line)            ; 搜索历史
       ("M-y" . consult-yank-pop)))      ; 剪贴板历史


       (use-package quickrun
       :ensure t
       :bind ("C-c r" . quickrun))

       (use-package highlight-thing
       		 :config
       (global-highlight-thing-mode))

       ;; 基本配置
       (menu-bar-mode -1)
       (tool-bar-mode -1)
       (scroll-bar-mode -1)
       (setq visible-bell t)

       ;; 鼠标支持
       (when (not (display-graphic-p))
       (xterm-mouse-mode 1)
       (setq mouse-yank-at-point t)
       (global-set-key [mouse-4] (lambda () (interactive) (scroll-down 1)))
       (global-set-key [mouse-5] (lambda () (interactive) (scroll-up 1))))


       ;; 包配置
       (use-package lsp-mode
       :ensure t
       :init
       (setq lsp-keymap-prefix "C-c l")
       :hook (
       (prog-mode . lsp)
       (lsp-mode . lsp-enable-which-key-integration))
       :commands lsp
       :config
       ;; 设置不同语言的 LSP 服务器
       (setq lsp-language-id-configuration
       '((nix-mode . "nix")
       (python-mode . "python")
       (rust-mode . "rust")
       (go-mode . "go")
       (js-mode . "javascript")
       (typescript-mode . "typescript")
       (c-mode . "c")
       (c++-mode . "cpp")
       (haskell-mode . "haskell")
       (terraform-mode . "terraform")))

       ;; Register Nix LSP clients with error handling
       (when (executable-find "nixd")
       (lsp-register-client
       (make-lsp-client :new-connection (lsp-stdio-connection '("nixd"))
       :major-modes '(nix-mode)
       :server-id 'nixd)))

       (when (executable-find "nil")
       (lsp-register-client
       (make-lsp-client :new-connection (lsp-stdio-connection '("nil"))
       :major-modes '(nix-mode)
       :server-id 'nil))))


       (add-hook 'nix-mode-hook
       (lambda ()
       (require 'lsp-mode)
       (lsp-deferred)))  ;; 延迟加载 LSP 以提升启动速度

       (use-package format-all
       :hook ((prog-mode . format-all-ensure-formatter))
       :config
       (add-hook 'before-save-hook 'format-all-buffer))

       ;; Nix 特定配置
       (setq nix-nixfmt-bin "${pkgs.nixfmt-classic}/bin/nixfmt")
       (add-hook 'nix-mode-hook
       (lambda ()
       (setq-local format-all-formatters '(("Nix" nixfmt)))))

       (use-package yasnippet
       :config
       (yas-global-mode 1))

       (use-package lsp-treemacs
       :after lsp)

       (use-package helm-lsp
       :after lsp
       :commands helm-lsp-workspace-symbol)

       (use-package projectile
       :config
       (projectile-mode +1))

       (use-package hydra
       :config
       (defhydra hydra-lsp (:exit t :hint nil)
       "
       LSP:
       ^Workspace^               ^Code^
       -------------------------------
       _s_: Symbol               _a_: Actions
       _r_: References           _e_: Flycheck
       _d_: Diagnostics          _f_: Format
       _D_: Peek diagnostics     _R_: Rename
       _g_: Goto definition      _h_: Help
       _G_: Peek definition      _i_: Implementation
       _t_: Type definition      _H_: Hover
       _T_: Peek type definition
       "
       ("s" helm-lsp-workspace-symbol)
       ("r" lsp-find-references)
       ("d" lsp-treemacs-errors-list)
       ("D" lsp-ui-peek-find-diagnostics)
       ("g" lsp-find-definition)
       ("G" lsp-ui-peek-find-definition)
       ("t" lsp-find-type-definition)
       ("T" lsp-ui-peek-find-type-definition)
       ("a" lsp-execute-code-action)
       ("e" flycheck-list-errors)
       ("f" lsp-format-buffer)
       ("R" lsp-rename)
       ("h" lsp-describe-thing-at-point)
       ("i" lsp-find-implementation)
       ("H" lsp-ui-doc-glance)))

       (use-package flycheck
       :init (global-flycheck-mode))
       (use-package company
       :config
       (global-company-mode)
       (setq company-minimum-prefix-length 1
       company-idle-delay 0.1))

       (use-package avy
       :bind (("C-'" . avy-goto-char-2)))

       (use-package which-key
       :init (which-key-mode)
       :config
       (setq which-key-idle-delay 0.5))

       (use-package helm-xref
       :config
       (setq xref-show-xrefs-function 'helm-xref-show-xrefs))

       (use-package dap-mode
       :after lsp-mode
       :config
       (dap-auto-configure-mode)
       (dap-ui-controls-mode 1)
       (require 'dap-gdb-lldb)
       (require 'dap-node))

       ;; 自动为 .nix 文件启用 nix-mode
       (add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))

       ;; 可选：设置更好的缩进
       (add-hook 'nix-mode-hook 'lsp-deferred)  

    '';
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true; # 启用 systemd 集成

    # 基础配置
    settings = {
      exec-once = [
        "waybar"
        "mako"
        "swaybg -i ~/dl/2974bb53bf6d8d27f78c7206cbc5ae90.jpeg"
        "fcitx5 -d"
        "wl-paste --watch cliphist store"
        "emacs"
        "kitty"
        "google-chrome-stable"
        "gammastep"
        "nemo"
      ];
      "$mainMod" = "SUPER"; # 定义主修饰键
      input = {
        kb_layout = "us";
        follow_mouse = 1;
      };

      general = {
        gaps_in = 3;
        gaps_out = 5;
        border_size = 2;
      };
      monitor = [ "DP-1, 2560x1440@60, 0x0, 1" "eDP-1, disable" ];
      #monitor = [ "eDP-1, 1920x1080@60, auto, 1" ];

      animations = {
        # 贝塞尔曲线定义 (修正参数格式)
        bezier = [
          "speed, 0.05, 0.95, 0.5, 1.0" # 最后一个参数应为 1.0 而非 0.5
          "fastOut, 0.36, 0, 0.66, -0.56"
          "fastIn, 0.25, 1, 0.5, 1"
        ];

        # 动画规则 (修正语法错误)
        animation = [
          "windows, 1, 4, fastOut, popin 10%"
          "windowsOut, 1, 3, fastIn"
          "workspaces, 1, 4, speed"
          "border, 1, 2, default" # 修正拼写错误 ("default" 不是 "defualt")
        ];
      };

      bind = [
        #  "SUPER, RETURN, exec, ${pkgs.kitty}/bin/kitty"
        "SUPER, Q, killactive"
        "SUPER, D, exec, ${pkgs.rofi-wayland}/bin/rofi -show drun"
        "SUPER, Escape, exec, wlogout --protocol layer-shell" # 绑定快捷键
        "SUPER, L, exec, swaylock -f -c 000000"
        "ALT_SHIFT, Delete, exec, systemctl reboot"

        "SUPER, RETURN, exec, kitty"
        "$mainMod SHIFT, Return, exec, kitty --title=kitty-dropdown -o initial_window_width=1200 -o initial_window_height=600"
        # "$mod, RETURN, exec, ${pkgs.kitty}/bin/kitty --directory=~"

        "$mainMod, B, exec, ${pkgs.google-chrome}/bin/google-chrome-stable"
        # 可选：带工作目录的启动方式
        "$mainMod, E, exec, emacs"
        # "$mainMod SHIFT, E, exec, ${pkgs.kitty}/bin/kitty -e ${pkgs.emacs}/bin/emacs -nw"

        # 切换到工作区 1-9
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        # ... 延续到 9

        # 移动窗口到工作区
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        # ... 延续到 9

        # 相对导航
        "$mainMod, left, workspace, e-1"
        "$mainMod, right, workspace, e+1"

        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizeactive"

      ];

      windowrulev2 = [
        "rounding 0, class:^(xwaylandvideobridge)$" # 屏幕共享窗口无圆角
        "rounding 10, title:^(.*)(Picture-in-Picture)(.*)$" # PIP 窗口小圆角
        # 基础浮动
        # "float, class:^(kitty)$"
        # "center 1, class:^(kitty)$, floating:1"

        # 临时终端浮动
        "float, title:^(kitty-dropdown)$"
        "center 1, title:^(kitty-dropdown)$"
        "animation popin, title:^(kitty-dropdown)$"
        # "size 80% 50%, title:^(kitty-dropdown)$" 

        "movecursor 0 0, floating:1"
        "workspace 1, class:^(kitty)$"
        "workspace 2, class:^(google-chrome)$"
        "workspace 3, class:^(Emacs)$"
        "workspace 4, class:^(nemo)$"

      ];

      decoration = {
        # 圆角设置
        rounding = 16; # 推荐值 8-24（像素）
        # multisample_edges = true;     # 必须添加！消除圆角锯齿

        # 透明度
        active_opacity = 0.95; # 活动窗口透明度（0.9-1.0）
        inactive_opacity = 0.85; # 非活动窗口透明度（0.7-0.9）

        # 模糊效果
        blur = {
          enabled = false;
          size = 8; # 模糊半径（1-10）
          passes = 3; # 模糊迭代次数（1-4）
          new_optimizations = true; # 性能优化
          noise = 2.0e-2; # 建议添加噪点（0.01-0.05）
          contrast = 1.1; # 建议添加对比度（1.0-1.3）
        };

      };

    };
    extraConfig = "";
  };

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    globals.mapleader = " "; # 设置 Leader 键

    plugins = {
      web-devicons.enable = true;
      # 内置插件管理
      telescope.enable = true; # 无需额外配置
      lualine.enable = true;

      # 自定义插件
      cmp.settings = {
        enable = true;
        autoEnableSources = true;
        sources = [ { name = "nvim_lsp"; } { name = "path"; } ];
      };
      # LSP 相关配置
      lsp = {
        enable = true;
        servers = {
          nixd.enable = true; # Nix
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
          pyright.enable = true; # Python
        };
        keymaps = {
          silent = true;
          lspBuf = {
            gd = "definition";
            gr = "references";
            K = "hover";
          };
        };
      };

    };
    keymaps = [
      {
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<cr>";
        options.desc = "Find files";
      }
      {
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<cr>";
        options.desc = "Live grep";
      }
    ];
    # 自动安装 LSP 的正确方式（新版本） 
    # 如果需要自动安装 LSP
    extraConfigLua = ''
      vim.opt.number = true; 
      vim.opt.relativenumber = true; 
      vim.opt.tabstop = 4; 
      require("mason").setup()
      require("mason-lspconfig").setup({
      automatic_installation = true
      })

      -- 设置 ESC 替代键
      vim.keymap.set('i', 'jk', '<ESC>', { noremap = true, silent = true })
      vim.keymap.set('v', 'jk', '<ESC>', { noremap = true, silent = true })

      -- 设置超时时间（毫秒）
      vim.opt.timeoutlen = 300
    '';
    # 手动添加 mason.nvim 和 mason-lspconfig.nvim
    extraPlugins = with pkgs.vimPlugins; [ mason-nvim mason-lspconfig-nvim ];
    plugins = {
      conform-nvim = {
        enable = true;
        settings.formatters = {
          nixpkgs_fmt = { command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt"; };
        };
      };
      # 启用 mini.icons
      mini = {
        enable = true;
        modules = {
          icons = { };
          comment = {
            mappings = {
              # 解决 gc/gcc 冲突
              textobject = "gc"; # 将 textobject 映射改为 gc
            };
          };
        };
      };
      auto-save = {
        enable = true;
        settings = {
          enabled = true;
          trigger_events = {
            # 注意这里使用花括号表示属性集
            "InsertLeave" = true;
            "TextChanged" = true;
            "FocusLost" = true;
          };
          executionMessage = {
            enable = true; # 替代原来的 execution_message
            message = "Saved at ${"%H:%M:%S"}";
            dim = 0.18;
            cleaningInterval = 1250;
          };
        };
      };

    };
    extraPackages = [ pkgs.nixpkgs-fmt ];
  };

  programs.tmux = {
    enable = true;
    terminal = "screen-256color"; # 支持真彩色
    historyLimit = 5000;
    extraConfig = ''
      # 基础设置
      set -g mouse on                          # 启用鼠标
      set -g base-index 1                      # 窗口编号从1开始
      set -g pane-base-index 1                 # 面板编号从1开始
      set -g renumber-windows on               # 关闭窗口后重新编号
      set -g default-terminal "tmux-256color"  # 更好的终端支持
      set -ag terminal-overrides ",xterm-256color:RGB"  # 真彩色支持

      # 快捷键前缀改为 Ctrl-a (默认是 Ctrl-b)
      unbind C-b
      set -g prefix C-a
      bind C-a send-prefix

      # 面板分割快捷键
      bind | split-window -h
      bind - split-window -v

      # 面板导航
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # 状态栏配置
      set -g status-style bg=default
      set -g status-left "#[fg=green]#S #[fg=white]• "
      set -g status-right "#[fg=white]%Y-%m-%d %H:%M "
      set -g window-status-format "#I:#W"
      set -g window-status-current-format "#[fg=yellow]#I:#W"

      # 启用剪贴板集成 (需要xclip)
      bind -T copy-mode-vi y send -X copy-pipe-and-cancel "xclip -in -selection clipboard"
    '';
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    theme = "sidebar"; # 内置主题（或自定义路径）
    # 或直接指定主题内容
    # theme = ''
    #   * { background: #282828; text-color: #ebdbb2; }
    #   listview { lines: 5; }
    # '';

    extraConfig = {
      modi = "drun,run,window"; # 启用应用、命令、窗口模式
      show-icons = true;
      icon-theme = "Papirus"; # 需要确保图标主题已安装
      terminal = "kitty"; # 设置默认终端
    };
  };

  # Program configurations
  programs = {
    bash = {
      enable = true;
      shellAliases = {
        ll = "eza -l --icons";
        la = "eza -la --icons";
        update = "sudo nixos-rebuild switch --flake ~/nix/#nixos";
      };
    };

    git = {
      enable = true;
      userName = "guoe2005";
      userEmail = "guoe2005@126.com";
      extraConfig = {
        credential.helper = "${
            pkgs.git.override { withLibsecret = true; }
          }/bin/git-credential-libsecret";
        push = { autoSetupRemote = true; };
        pull.rebase = true;
      };
    };
  };

  # Systemd services
  services = {
    gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-qt; # Changed from pinentryFlavor
    };
  };

  # XDG configuration
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      documents = "${config.home.homeDirectory}/docs";
      download = "${config.home.homeDirectory}/dl";
    };
  }; # Added missing semicolon and closing brace

  home.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";

    CLIPBOARD_COPY_CMD = "wl-copy --foreground --type text/plain";
    CLIPBOARD_PASTE_CMD = "wl-paste --no-newline";

  };
  programs.waybar.settings.mainBar.modules-right = [ "hyprland/workspaces" ];
  programs.waybar.settings.mainBar."hyprland/workspaces" = {
    format = "{icon}";
    active-only = false;
    on-click = "activate";
  };
  programs.kitty = {
    enable = true;
    font.name = "Fira Code";
    font.size = 12;
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      confirm_os_window_close = 0; # 关闭确认提示
    };
    extraConfig = ''
      # 自定义 keybindings
      map ctrl+shift+v paste_from_clipboard
      map ctrl+shift+c copy_to_clipboard
    '';
    theme = "Gruvbox Dark";
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];

      theme = "robbyrussell"; # 默认主题
      # 或自定义主题（如 powerlevel10k）
      # custom = "$HOME/.config/zsh/custom";
    };
    shellAliases = {
      ll = "ls -l";
      s = ''
        if [[ "$(basename "$PWD")" == "nix" ]]; then
        sudo nixos-rebuild switch --flake .
        else
        cd ~/nix && sudo nixos-rebuild switch --flake .
        fi
      '';
      fmt = ''
        if [[ "$(basename "$PWD")" == "nix" ]]; then
        nixpkgs-fmt *.nix
        else
        cd ~/nix && nixpkgs-fmt *.nix
        fi
      '';
    };
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.0";
          sha256 = "sha256-KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.7.1";
          sha256 = "sha256-gOG0NLlaJfotJfs+SUhGgLTNOnGLjoqnUp54V9aFJg8=";
        };
      }
    ];
  };

  programs.zathura = {
    enable = true;
    options = {
      # 基础设置
      scroll-step = 50;
      zoom-min = 10;
      default-bg = "#282828"; # Gruvbox 背景色
      default-fg = "#ebdbb2"; # Gruvbox 前景色

      # 高亮颜色
      highlight-color = "#458588";
      highlight-active-color = "#d79921";

      # 启用增量搜索
      incremental-search = true;

      synctex = true;
      synctex-editor-command =
        "${pkgs.vim}/bin/vim --servername synctex --remote-silent +%{line} %{input}";
    };

    # 键位映射（类 Vim 风格）
    mappings = {
      "<Ctrl-h>" = "navigate previous";
      "<Ctrl-l>" = "navigate next";
      "f" = "toggle_fullscreen";
      "b" = "scroll half-up";
      " " = "scroll half-down";
    };

    # 额外配置（直接写入 zathurarc）
    extraConfig = ''
      # 启用反向搜索（需配合 synctex）
      set synctex true
      set synctex-editor-command "nvr --remote-silent +%{line} %{input}"
    '';
  };
  home.file = {
    #    # Neovim configuration (recursive directory)
    #    ".config/nvim" = mkSymlink "nvim";
    #
    #    # Shell configuration
    #    ".zshrc".source = "${dotfilesDir}/zsh/.zshrc";
    #    ".zsh_plugins".source = "${dotfilesDir}/zsh/plugins";
    #
    #    # Tmux configuration
    #    ".tmux.conf".source = "${dotfilesDir}/tmux/.tmux.conf";
    #    ".tmux/plugins".source = "${dotfilesDir}/tmux/plugins";
    #
    #    # Make specific files executable
    #    ".local/bin/backup" = {
    #      source = "${dotfilesDir}/scripts/backup.sh";
    #      executable = true;
    #    };
    #  };
    #
    #  xdg.configFile = {
    #    # Window manager configurations
    #    "i3/config".source = "${dotfilesDir}/i3/config";
    #    "polybar/config.ini".source = "${dotfilesDir}/polybar/config.ini";
    #
    #    # Terminal emulators
    #    "alacritty/alacritty.yml".source = "${dotfilesDir}/alacritty/alacritty.yml";
    #    "kitty/kitty.conf".source = "${dotfilesDir}/kitty/kitty.conf";
    #  };
    #
    #  # Set executable permissions for specified files
    #  home.activation.setExecutable = config.lib.dag.entryAfter ["writeBoundary"] ''
    #    ${pkgs.lib.concatMapStrings (file: ''
    #      if [ -e "${config.home.homeDirectory}/${file}" ]; then
    #        chmod +x "${config.home.homeDirectory}/${file}"
    #      fi
    #    '') executableFiles}
    #  '';
    #
    #  # Optional: Auto-update dotfiles repo
    #  home.activation.updateDotfiles = config.lib.dag.entryAfter ["writeBoundary"] ''
    #    if [ -d "${dotfilesDir}/.git" ]; then
    #      echo "Updating dotfiles repository..."
    #      (cd ${dotfilesDir} && git pull --rebase)
    #    else
    #      echo "Cloning dotfiles repository..."
    #      git clone https://github.com/yourusername/dotfiles ${dotfilesDir}
    #    fi
    #  '';
    #
    #  # Optional: Backup existing dotfiles before overwriting
    #  home.activation.backupDotfiles = config.lib.dag.entryBefore ["writeBoundary"] ''
    #    echo "Backing up existing dotfiles..."
    #    backup_dir="${config.home.homeDirectory}/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
    #    mkdir -p "$backup_dir"
    #    
    #    for target in \
    #      "${config.home.homeDirectory}/.config/nvim" \
    #      "${config.home.homeDirectory}/.zshrc" \
    #      "${config.home.homeDirectory}/.tmux.conf"; do
    #      if [ -e "$target" ]; then
    #        mv "$target" "$backup_dir/"
    #      fi
    #    done
    #  '';

    ".config/waybar/config".text = ''
      // =============================================================================
      //
      // Waybar configuration
      //
      // Configuration reference: https://github.com/Alexays/Waybar/wiki/Configuration
      //
      // =============================================================================

      {
      // -------------------------------------------------------------------------
      // Global configuration
      // -------------------------------------------------------------------------

      "layer": "top",

      "position": "top",

      // If height property would be not present, it'd be calculated dynamically
      "height": 30,

      "modules-left": [
      "hyprland/workspaces",
      ],
      "modules-center": [
      "hyprland/window"
      ],
      "modules-right": [
      "network",
      "memory",
      "cpu",
      "temperature",
      "custom/keyboard-layout",
      "battery",
      "tray",
      "clock#date",
      "clock#time"
      ],


      // -------------------------------------------------------------------------
      // Modules
      // -------------------------------------------------------------------------

      "battery": {
      "interval": 10,
      "states": {
      "warning": 30,
      "critical": 15
      },
      // Connected to AC
      "format": "  {icon}  {capacity}%", // Icon: bolt
      // Not connected to AC
      "format-discharging": "{icon}  {capacity}%",
      "format-icons": [
      "", // Icon: battery-full
      "", // Icon: battery-three-quarters
      "", // Icon: battery-half
      "", // Icon: battery-quarter
      ""  // Icon: battery-empty
      ],
      "tooltip": true
      },

      "clock#time": {
      "interval": 1,
      "format": "{:%H:%M:%S}",
      "tooltip": false
      },

      "clock#date": {
      "interval": 10,
      "format": "  {:%e %b %Y}", // Icon: calendar-alt
      "tooltip-format": "{:%e %B %Y}"
      },

      "cpu": {
      "interval": 5,
      "format": "  {usage}% ({load})", // Icon: microchip
      "states": {
      "warning": 70,
      "critical": 90
      }
      },

      "custom/keyboard-layout": {
      "exec": "hyprlandmsg -t get_inputs | grep -m1 'xkb_active_layout_name' | cut -d '\"' -f4",
      // Interval set only as a fallback, as the value is updated by signal
      "interval": 30,
      "format": "  {}", // Icon: keyboard
      // Signal sent by hyprland key binding (~/.config/hyprland/key-bindings)
      "signal": 1, // SIGHUP
      "tooltip": false
      },

      "memory": {
      "interval": 5,
      "format": "  {}%", // Icon: memory
      "states": {
      "warning": 70,
      "critical": 90
      }
      },

      "network": {
      "interval": 5,
      "format-wifi": "  {essid} ({signalStrength}%)", // Icon: wifi
      "format-ethernet": "  {ifname}: {ipaddr}/{cidr}", // Icon: ethernet
      "format-disconnected": "⚠  Disconnected",
      "tooltip-format": "{ifname}: {ipaddr}"
      },

      "hyprland/mode": {
      "format": "<span style=\"italic\">  {}</span>", // Icon: expand-arrows-alt
      "tooltip": false
      },

      "hyprland/window": {
      "format": "{}",
      "max-length": 120
      },

      "hyprland/workspaces": {
      "all-outputs": false,
      "disable-scroll": true,
      "format": "{name}",
      "format-icons": {
      "1:www": "", // Icon: firefox-browser
      "2:mail": "", // Icon: mail
      "3:editor": "", // Icon: code
      "4:terminals": "", // Icon: terminal
      "5:portal": "", // Icon: terminal
      "urgent": "",
      "focused": "",
      "default": ""
      },


      "persistent-workspaces": {  // 新增：固定工作区到显示器
      "DP-1": [1, 2, 3],     // 主显示器绑定工作区1-3
      "eDP-1": [4, 5]     // 副显示器绑定工作区4-5
      },
      },
      //"pulseaudio": {
      //    //"scroll-step": 1,
      //    "format": "{icon}  {volume}%",
      //    "format-bluetooth": "{icon}  {volume}%",
      //    "format-muted": "",
      //    "format-icons": {
      //        "headphones": "",
      //        "handsfree": "",
      //        "headset": "",
      //        "phone": "",
      //        "portable": "",
      //        "car": "",
      //        "default": ["", ""]
      //    },
      //    "on-click": "pavucontrol"
      //},

      "temperature": {
      "critical-threshold": 80,
      "interval": 5,
      "format": "{icon}  {temperatureC}°C",
      "format-icons": [
      "", // Icon: temperature-empty
      "", // Icon: temperature-quarter
      "", // Icon: temperature-half
      "", // Icon: temperature-three-quarters
      ""  // Icon: temperature-full
      ],
      "tooltip": true
      },

      "tray": {
      "icon-size": 21,
      "spacing": 10
      }

      }

    '';
    ".config/waybar/style.css".text = ''
      /* =============================================================================
      *
      * Waybar configuration
      *
      * Configuration reference: https://github.com/Alexays/Waybar/wiki/Configuration
      *
      * =========================================================================== */

      /* -----------------------------------------------------------------------------
      * Keyframes
      * -------------------------------------------------------------------------- */

      @keyframes blink-warning {
      70% {
      color: white;
      }

      to {
      color: white;
      background-color: orange;
      }
      }

      @keyframes blink-critical {
      70% {
      color: white;
      }

      to {
      color: white;
      background-color: red;
      }
      }


      /* -----------------------------------------------------------------------------
      * Base styles
      * -------------------------------------------------------------------------- */

      /* Reset all styles */
      * {
      border: none;
      border-radius: 0;
      min-height: 0;
      margin: 0;
      padding: 0;
      }

      /* The whole bar */
      #waybar {
      background: #323232;
      color: white;
      font-family: Cantarell, Noto Sans, sans-serif;
      font-size: 13px;
      }

      /* Each module */
      #battery,
      #clock,
      #cpu,
      #custom-keyboard-layout,
      #memory,
      #mode,
      #network,
      #pulseaudio,
      #temperature,
      #tray {
      padding-left: 10px;
      padding-right: 10px;
      }


      /* -----------------------------------------------------------------------------
      * Module styles
      * -------------------------------------------------------------------------- */

      #battery {
      animation-timing-function: linear;
      animation-iteration-count: infinite;
      animation-direction: alternate;
      }

      #battery.warning {
      color: orange;
      }

      #battery.critical {
      color: red;
      }

      #battery.warning.discharging {
      animation-name: blink-warning;
      animation-duration: 3s;
      }

      #battery.critical.discharging {
      animation-name: blink-critical;
      animation-duration: 2s;
      }

      #clock {
      font-weight: bold;
      }

      #cpu {
      /* No styles */
      }

      #cpu.warning {
      color: orange;
      }

      #cpu.critical {
      color: red;
      }

      #memory {
      animation-timing-function: linear;
      animation-iteration-count: infinite;
      animation-direction: alternate;
      }

      #memory.warning {
      color: orange;
      }

      #memory.critical {
      color: red;
      animation-name: blink-critical;
      animation-duration: 2s;
      }

      #mode {
      background: #64727D;
      border-top: 2px solid white;
      /* To compensate for the top border and still have vertical centering */
      padding-bottom: 2px;
      }

      #network {
      /* No styles */
      }

      #network.disconnected {
      color: orange;
      }

      #pulseaudio {
      /* No styles */
      }

      #pulseaudio.muted {
      /* No styles */
      }

      #custom-spotify {
      color: rgb(102, 220, 105);
      }

      #temperature {
      /* No styles */
      }

      #temperature.critical {
      color: red;
      }

      #tray {
      /* No styles */
      }

      #window {
      font-weight: bold;
      }

      #workspaces button {
      border-top: 2px solid transparent;
      /* To compensate for the top border and still have vertical centering */
      padding-bottom: 2px;
      padding-left: 10px;
      padding-right: 10px;
      color: #888888;
      }

      #workspaces button.focused {
      border-color: #4c7899;
      color: white;
      background-color: #285577;
      }

      #workspaces button.urgent {
      border-color: #c9545d;
      color: #c9545d;
      }

    '';

    # ".emacs.d/init.el".text = ''
    #   (add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp"))
    #   (add-to-list 'load-path (expand-file-name "~/.emacs.d/magit/lisp"))
    #
    #   (setq package-archives
    #        '( 
    #           ("melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
    #           ("gnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
    #           ("org" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/org/") 
    #        )
    #   )
    #   ;; refresh mirrors
    #   ;;个别时候会出现签名检验失败
    #   (setq package-check-signature nil) 
    #
    #   ;; 初始化软件包管理器
    #   (require 'package)
    #   (unless (bound-and-true-p package--initialized)
    #       (package-initialize))
    #
    #   ;; 刷新软件源索引
    #   (unless package-archive-contents
    #       (package-refresh-contents))
    #
    #   ;; 第一个扩展插件:use-package,用来批量统一管理软件包
    #   (unless (package-installed-p 'use-package)
    #       (package-refresh-contents)
    #       (package-install 'use-package))
    #   (setq use-package-always-ensure t
    #         use-package-always-defer t
    #         use-package-enable-imenu-support t
    #         use-package-expand-minimally t)
    #
    #   (use-package restart-emacs)
    #   (use-package gruvbox-theme
    #     :init (load-theme 'gruvbox-dark-soft t))
    #
    #   ;; (require 'package)
    #   ;; (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
    #   ;; (package-initialize)
    #
    #   (setq package-selected-packages '(lsp-mode yasnippet lsp-treemacs helm-lsp
    #       projectile hydra flycheck company avy which-key helm-xref dap-mode))
    #
    #   (when (cl-find-if-not #'package-installed-p package-selected-packages)
    #     (package-refresh-contents)
    #     (mapc #'package-install package-selected-packages))
    #
    #   ;; sample `helm' configuration use https://github.com/emacs-helm/helm/ for details
    #   (helm-mode)
    #   (require 'helm-xref)
    #   (define-key global-map [remap find-file] #'helm-find-files)
    #   (define-key global-map [remap execute-extended-command] #'helm-M-x)
    #   (define-key global-map [remap switch-to-buffer] #'helm-mini)
    #
    #   (which-key-mode)
    #   (add-hook 'c-mode-hook 'lsp)
    #   (add-hook 'c++-mode-hook 'lsp)
    #
    #   (setq gc-cons-threshold (* 100 1024 1024)
    #         read-process-output-max (* 1024 1024)
    #         treemacs-space-between-root-nodes nil
    #         company-idle-delay 0.0
    #         company-minimum-prefix-length 1
    #         lsp-idle-delay 0.1)  ;; clangd is fast
    #
    #   (with-eval-after-load 'lsp-mode
    #     (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
    #     (require 'dap-cpptools)
    #     (yas-global-mode))
    #
    #   (global-set-key (kbd "<f3>") 'compile)
    #
    #   (require 'auto-save) ;; 加载自动保存模块
    #   (auto-save-enable)     ;; 开启自动保存功能
    #   (custom-set-variables
    #    ;; custom-set-variables was added by Custom.
    #    ;; If you edit it by hand, you could mess it up, so be careful.
    #    ;; Your init file should contain only one such instance.
    #    ;; If there is more than one, they won't work right.
    #    '(package-selected-packages
    #      '(avy company dap-mode flycheck helm-lsp helm-xref hydra ivy lsp-mode
    #   	 lsp-treemacs magit meow projectile which-key yasnippet)))
    #   (custom-set-faces
    #    ;; custom-set-faces was added by Custom.
    #    ;; If you edit it by hand, you could mess it up, so be careful.
    #    ;; Your init file should contain only one such instance.
    #    ;; If there is more than one, they won't work right.
    #    )
    #
    #   (xterm-mouse-mode t)
    #
    #   (ivy-mode 1)  ; 启用 ivy-mode
    #
    #   (use-package ace-window
    #     :ensure t
    #     :bind ("M-o" . ace-window))
    #
    #   (setq select-enable-clipboard t)      ; 与系统剪切板同步
    #   (setq select-enable-primary t)       ; 与 PRIMARY 选择（中键粘贴）同步
    #   (setq save-interprogram-paste-before-kill t)  ; 保存剪切板内容到 kill-ring
    #
    #   (use-package meow
    #     :ensure t
    #     :init
    #     (setq meow-cheatsheet-layout 'qwerty)
    #     :config
    #     (meow-global-mode 1)
    #
    #     ;; 定义 leader 键（默认为 SPC）
    #     (meow-leader-define-key
    #      '("f" . find-file)
    #      '("b" . switch-to-buffer)
    #      '("s" . save-buffer))
    #
    #     ;; 定义正常模式键位
    #     (meow-normal-define-key
    #      '("0" . meow-expand-0)
    #      '("1" . meow-expand-1)
    #      '("2" . meow-expand-2)
    #      '("3" . meow-expand-3)
    #      '("4" . meow-expand-4)
    #      '("5" . meow-expand-5)
    #      '("6" . meow-expand-6)
    #      '("7" . meow-expand-7)
    #      '("8" . meow-expand-8)
    #      '("9" . meow-expand-9)
    #      '("-" . negative-argument)
    #      '(";" . meow-reverse)
    #      '("," . meow-inner-of-thing)
    #      '("." . meow-bounds-of-thing)
    #      '("a" . meow-append)
    #      '("b" . meow-back-word)
    #      '("c" . meow-change)
    #      '("d" . meow-delete)
    #      '("e" . meow-next-word)
    #      '("f" . meow-find)
    #      '("g" . meow-cancel-selection)
    #      '("h" . meow-left)
    #      '("i" . meow-insert)
    #      '("j" . meow-next)
    #      '("k" . meow-prev)
    #      '("l" . meow-right)
    #      '("m" . meow-join)
    #      '("n" . meow-search)
    #      '("o" . meow-block)
    #      '("p" . meow-yank)
    #      '("q" . meow-quit)
    #      '("r" . meow-replace)
    #      '("s" . meow-kill)
    #      '("t" . meow-till)
    #      '("u" . meow-undo)
    #      '("v" . meow-visit)
    #      '("w" . meow-mark-word)
    #      '("x" . meow-line)
    #      '("y" . meow-save)
    #      '("z" . meow-pop-selection)
    #      '("'" . repeat)
    #      '("<escape>" . meow-insert-exit)))
    # '';
  };

}

