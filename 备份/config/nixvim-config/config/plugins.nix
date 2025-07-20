{pkgs,...}:
{
  plugins={
    tmux-navigator = {
      enable = true;
      keymaps = [
        {
          action = "left";
          key = "<C-w>h";
        }
        {
          action = "down";
          key = "<C-w>j";
        }
        {
          action = "up";
          key = "<C-w>k";
        }
        {
          action = "right";
          key = "<C-w>l";
        }
        {
          action = "previous";
          key = "<C-n>";
        }
      ];
    };

    vim-bbye = {
      enable = true;
    };
    web-devicons.enable = true;
    persistence.enable = true;

  oil = {
      enable = true;
    };

  trouble = {
    enable = true;
  };

    alpha = {
      enable = true;
      theme = "dashboard";
      # iconsEnabled = true; # Deprecated
    };

    illuminate = {
      enable = true;
      underCursor = false;
      filetypesDenylist = [
        "Outline"
        "TelescopePrompt"
        "alpha"
        "harpoon"
        "reason"
      ];
    };

   neoscroll = {
      enable = true;
    };

    lint = {
      enable = true;
      lintersByFt = {
        text = ["vale"];
        json = ["jsonlint"];
        markdown = ["vale"];
        rst = ["vale"];
        ruby = ["ruby"];
        janet = ["janet"];
        inko = ["inko"];
        clojure = ["clj-kondo"];
        dockerfile = ["hadolint"];
        terraform = ["tflint"];
      };
    };
    friendly-snippets = {
      enable = true;
    };
    toggleterm = {
        enable = true;

        settings = {
          direction = "float";
          float_opts.border = "rounded";
          shading_factor = 2;
          size = 10;

          highlights = {
            Normal.link = "Normal";
            NormalNC.link = "NormalNC";
            NormalFloat.link = "NormalFloat";
            FloatBorder.link = "FloatBorder";
            StatusLine.link = "StatusLine";
            StatusLineNC.link = "StatusLineNC";
            WinBar.link = "WinBar";
            WinBarNC.link = "WinBarNC";
          };

        #   # https://github.com/AstroNvim/AstroNvim/blob/v4.7.7/lua/astronvim/plugins/toggleterm.lua#L66-L74
        #   on_create = ''
        # function(t)
        #   vim.opt_local.foldcolumn = "0"
        #   vim.opt_local.signcolumn = "no"
        #   if t.hidden then
        #     vim.keymap.set({ "n", "t", "i" }, "<F7>", function() t:toggle() end, { desc = "Toggle terminal", buffer = t.bufnr })
        #   end
        #   local term_name = rndname()
        #   vim.cmd(t.id .. "ToggleTermSetName " .. term_name)
        # end
        #   '';
        };

    };
    # render-markdown = {
    #   enable = true;
    #   settings = {
    #     enabled = true; # This lets you set whether the plugin should render documents from the start or not. Useful if you want to use a command like RenderMarkdown enable to start rendering documents rather than having it on by default.
    #     bullet = {
    #       icons = [
    #         "•"
    #       ];
    #       right_pad = 1;
    #     };
    #     code = {
    #       above = " ";
    #       below = " ";
    #       border = "thick";
    #       language_pad = 2;
    #       left_pad = 2;
    #       position = "right";
    #       right_pad = 2;
    #       sign = false;
    #       width = "block";
    #     };
    #     heading = {
    #       border = true;
    #       icons = [
    #         "1 "
    #         "2 "
    #         "3 "
    #         "4 "
    #         "5 "
    #         "6 "
    #       ];
    #       position = "inline";
    #       sign = false;
    #       width = "full";
    #     };
    #     render_modes = true;
    #     signs = {
    #       enabled = false;
    #     };
    #   };
    # };
    image = {
      enable = true;
      backend = "kitty";
      hijackFilePatterns = [
        "*.png"
        "*.jpg"
        "*.jpeg"
        "*.gif"
        "*.webp"
      ];
      maxHeightWindowPercentage = 25;
      tmuxShowOnlyInActiveWindow = true;
      integrations = {
        markdown = {
          enabled = true;
          downloadRemoteImages = true;
          filetypes = [
            "markdown"
            "vimwiki"
            "mdx"
          ];
        };
      };
    };

    # Prettier fancier command window
    noice = {
      enable = false;
    };
    nvim-snippets = {
      enable = false;
      settings = {
        create_autocmd = true;
        create_cmp_source = true;
        extended_filetypes = {
          typescript = [
            "javascript"
          ];
        };
        friendly_snippets = true;
        global_snippets = [
          "all"
        ];
        ignored_filetypes = [
          #  "lua"
        ];
        search_paths = [
          {
            __raw = "vim.fn.stdpath('config') .. '/snippets'";
          }
        ];
      };
    };

  };
  extraPlugins = with pkgs.vimPlugins;
    [
      vim-be-good
      headlines-nvim # Should load this in at the opening of filetypes that require this, namely Markdown.
      glow-nvim # Glow inside of Neovim
      clipboard-image-nvim
    ];
  # ++ [
  #   (pkgs.vimUtils.buildVimPlugin {
  #     pname = "markview.nvim";
  #     version = "0.0.1";
  #     src = pkgs.fetchFromGitHub {
  #       owner = "OXY2DEV";
  #       repo = "markview.nvim";
  #       rev = "a959d77ca7e9f05175e3ee4e582db40b338c9164";
  #       hash = "sha256-w6yn8aNcJMLRbzaRuj3gj4x2J/20wUROLM6j39wpZek=";
  #     };
  #   })
  #   # Just copy this block for a new plugin
  #   # (pkgs.vimUtils.buildVimPlugin {
  #   #   pname = "";
  #   #   src = pkgs.fetchFromGitHub {
  #   #     owner = "";
  #   #     repo = "";
  #   #     rev = "";
  #   #     sha256 = "";
  #   #   };
  #   # })
  # ];

  extraConfigLuaPre = ''
    if vim.g.have_nerd_font then
      require('nvim-web-devicons').setup {}
    end
  '';
}
