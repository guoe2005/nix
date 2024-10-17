{pkgs,...} :
{
  imports = [
    ./utils/auto-pairs.nix
    ./utils/autosave.nix
    ./utils/blankline.nix
    ./utils/wilder.nix
    ./options.nix
    ./treesitter.nix
    ./lightline.nix
    # ./obsidian.nix
    ./plenary.nix
    ./plugins.nix
  ];
  colorschemes.dracula.enable = true;
  plugins.web-devicons.enable = true;

  diagnostics = { virtual_lines.only_current_line = true; };

  extraConfigVim = ''
    autocmd BufRead,BufNewFile *.pl set filetype=prolog
    let g:lightline = {
    \ 'enable': {
    \   'tabline': 0
    \ }
    \ }
    inoremap <C-l> <Right>
    inoremap <C-j> <Down>
    inoremap <C-k> <Up>
    inoremap <C-h> <Left>
    '';

  globals.mapleader = " ";
  keymaps = [
    # Global
    # Default mode is "" which means normal-visual-op
    {
      # {
      #   key = "<C-n>";
      #   action = "<CMD>NvimTreeToggle<CR>";
      #   options.desc = "Toggle NvimTree";
      # }
      key = "<C-n>";
      action = "<CMD>Neotree<CR>";
      options.desc = "Toggle NeoTree";
    }
    {
      key = "<leader>c";
      action = "+context";
    }
    {
      key = "<leader>co";
      action = "<CMD>TSContextToggle<CR>";
      options.desc = "Toggle Treesitter context";
    }
    {
      key = "<leader>ct";
      action = "<CMD>CopilotChatToggle<CR>";
      options.desc = "Toggle Copilot Chat Window";
    }
    {
      key = "<leader>cf";
      action = "<CMD>CopilotChatFix<CR>";
      options.desc = "Fix the selected code";
    }
    {
      key = "<leader>cs";
      action = "<CMD>CopilotChatStop<CR>";
      options.desc = "Stop current Copilot output";
    }
    {
      key = "<leader>cr";
      action = "<CMD>CopilotChatReview<CR>";
      options.desc = "Review the selected code";
    }
    {
      key = "<leader>ce";
      action = "<CMD>CopilotChatExplain<CR>";
      options.desc = "Give an explanation for the selected code";
    }
    {
      key = "<leader>cd";
      action = "<CMD>CopilotChatDocs<CR>";
      options.desc = "Add documentation for the selection";
    }
    {
      key = "<leader>cp";
      action = "<CMD>CopilotChatTests<CR>";
      options.desc = "Add tests for my code";
    }

    # File
    {
      mode = "n";
      key = "<leader>f";
      action = "+find/file";
    }
    {
      # Format file
      key = "<leader>fm";
      action = "<CMD>lua vim.lsp.buf.format()<CR>";
      options.desc = "Format the current buffer";
    }

    # Git    
    {
      mode = "n";
      key = "<leader>g";
      action = "+git";
    }
    {
      mode = "n";
      key = "<leader>gt";
      action = "+toggles";
    }
    {
      key = "<leader>gtb";
      action = "<CMD>Gitsigns toggle_current_line_blame<CR>";
      options.desc = "Gitsigns current line blame";
    }
    {
      key = "<leader>gtd";
      action = "<CMD>Gitsigns toggle_deleted";
      options.desc = "Gitsigns deleted";
    }
    {
      key = "<leader>gd";
      action = "<CMD>Gitsigns diffthis<CR>";
      options.desc = "Gitsigns diff this buffer";
    }
    {
      mode = "n";
      key = "<leader>gr";
      action = "+resets";
    }
    {
      key = "<leader>grh";
      action = "<CMD>Gitsigns reset_hunk<CR>";
      options.desc = "Gitsigns reset hunk";
    }
    {
      key = "<leader>grb";
      action = "<CMD>Gitsigns reset_buffer<CR>";
      options.desc = "Gitsigns reset current buffer";
    }

    # Tabs
    {
      mode = "n";
      key = "<leader>t";
      action = "+tab";
    }
    {
      mode = "n";
      key = "<leader>tn";
      action = "<CMD>tabnew<CR>";
      options.desc = "Create new tab";
    }
    {
      mode = "n";
      key = "<leader>td";
      action = "<CMD>tabclose<CR>";
      options.desc = "Close tab";
    }
    {
      mode = "n";
      key = "<leader>ts";
      action = "<CMD>tabnext<CR>";
      options.desc = "Go to the sub-sequent tab";
    }
    {
      mode = "n";
      key = "<leader>tp";
      action = "<CMD>tabprevious<CR>";
      options.desc = "Go to the previous tab";
    }

    # Terminal
    {
      # Escape terminal mode using ESC
      mode = "t";
      key = "<esc>";
      action = "<C-\\><C-n>";
      options.desc = "Escape terminal mode";
    }

    # Trouble 
    {
      mode = "n";
      key = "<leader>d";
      action = "+diagnostics/debug";
    }
    {
      key = "<leader>dt";
      action = "<CMD>Trouble diagnostics toggle<CR>";
      options.desc = "Toggle trouble";
    }

    # Rust
    {
      mode = "n";
      key = "<leader>r";
      action = "+rust";
    }
    {
      # Start standalone rust-analyzer (fixes issues when opening files fromvnvim tree)
      mode = "n";
      key = "<leader>rs";
      action = "<CMD>RustStartStandaloneServerForBuffer<CR>";
      options.desc = "Start standalone rust-analyzer";
    }
    {
      mode = "i";
      key = "jj";
      action = "<Esc>";
    }
    {
      mode = "n";
      key = "<Leader>q";
      action = "<CMD>Bdelete<CR>";
    }
    {
      mode = "n";
      key = "<C-b>";
      action = "<CMD>BufferLineCycleNext<CR>";
    }
    {
      mode = "n";
      key = "<C-e>";
      action = "<CMD>q!<CR>";
    }
    {
      mode = "n";
      key = "<leader>fp";
      action = "<cmd>Telescope projects<CR>";
      options = {
        desc = "Projects";
      };
    }

    {
      mode = "n";
      key = "<leader>sd";
      action = "<cmd>Telescope diagnostics bufnr=0<cr>";
      options = {
        desc = "Document diagnostics";
      };
    }

    {
      mode = "n";
      key = "<leader>st";
      action = "<cmd>TodoTelescope<cr>";
      options = {
        silent = true;
        desc = "Todo (Telescope)";
      };
    }
  ];
  extraConfigLua = ''
    vim.opt.conceallevel = 1
    --   require('telekasten').setup({
    -- home = vim.fn.expand("~/Downloads/obsidian"), -- Put the name of your notes directory here
    -- })
    local telescope = require('telescope')
    telescope.setup{
      pickers = {
        colorscheme = {
          enable_preview = true
        }
      }
    }

    '';
extraPlugins = with pkgs.vimPlugins;
    [
      vim-be-good
      headlines-nvim # Should load this in at the opening of filetypes that require this, namely Markdown.
      glow-nvim # Glow inside of Neovim
      clipboard-image-nvim
    ]
    ++ [
      (pkgs.vimUtils.buildVimPlugin {
      pname = "markview.nvim";
      version = "0.0.1";
      src = pkgs.fetchFromGitHub {
        owner = "OXY2DEV";
        repo = "markview.nvim";
        rev = "a959d77ca7e9f05175e3ee4e582db40b338c9164";
        hash = "sha256-w6yn8aNcJMLRbzaRuj3gj4x2J/20wUROLM6j39wpZek=";
      };
    })
      # Just copy this block for a new plugin
      # (pkgs.vimUtils.buildVimPlugin {
      #   pname = "";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "";
      #     repo = "";
      #     rev = "";
      #     sha256 = "";
      #   };
      # })
    ];

}
