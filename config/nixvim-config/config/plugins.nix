{pkgs,...}:
{
  plugins={
    vim-bbye = {
      enable = true;
    };
    web-devicons.enable = true;
    persistence.enable = true;

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
        hide_numbers = false;
        autochdir = true;
        close_on_exit = true;
        # direction = "hori";
        open_mapping = "[[<C-t>]]"; 
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
      enable = true;
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
}
