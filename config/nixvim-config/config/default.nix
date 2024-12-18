{
  imports = [
    ./lsp/default.nix
    ./lsp/fidget.nix
    ./lsp/ionide.nix
    ./lsp/none-ls.nix
    ./lsp/trouble.nix
    ./utils/auto-pairs.nix
    ./utils/autosave.nix
    ./utils/blankline.nix
    ./utils/telescope.nix
    ./utils/which-key.nix
    ./utils/wilder.nix
    ./bufferline.nix
    ./cmp.nix
    ./git.nix
    ./notify.nix
    ./markview.nix
    ./nvim-tree.nix
    ./options.nix
    ./treesitter.nix
    ./lightline.nix
    ./lazygit.nix
    ./neo-tree.nix
    ./obsidian.nix
    ./plenary.nix
    # ./telekasten.nix
    ./plugins.nix
    ./orgmode.nix
    ./fcitx.nix
    ./neorg.nix
  ];
  colorschemes.dracula.enable = true;
  # colorschemes.shine.enable = true;
  plugins.web-devicons.enable = true;

  diagnostics = { virtual_lines.only_current_line = true; };

  extraConfigVim = ''
    autocmd BufRead,BufNewFile *.pl set filetype=prolog
    let g:lightline = {
    \ 'enable': {
    \   'tabline': 0
    \ }
    \ }
    inoremap <C-h> <Left>
    inoremap <C-j> <Up>
    inoremap <C-k> <Down>
    inoremap <C-l> <Right>
    '';

  globals.mapleader = " ";
  keymaps = [
    # Global
    # Default mode is "" which means normal-visual-op
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
      key = "<Leader>bn";
      action = "<CMD>BufferLineCycleNext<CR>";
    }
    {
      mode = "n";
      key = "<Leader>tf";
      action = "<Cmd>ToggleTerm direction=float<CR>";
      options.desc = "Open floating terminal";
    }
    {
      mode = "n";
      key = "<Leader>th";
      action = "<Cmd>ToggleTerm size=10 direction=horizontal<CR>";
      options.desc = "Open terminal in horizontal split";
    }
    {
      mode = "n";
      key = "<Leader>tv";
      action = "<Cmd>ToggleTerm size=80 direction=vertical<CR>";
      options.desc = "Open terminal in vertical split";
    }
    {
      mode = "n";
      key = "<F7>";
      action = "<Cmd>execute v:count . 'ToggleTerm'<CR>";
      options.desc = "Toggle terminal";
    }
    {
      mode = "t";
      key = "<F7>";
      action = "<Cmd>ToggleTerm<CR>";
      options.desc = "Toggle terminal";
    }
    {
      mode = "i";
      key = "<F7>";
      action = "<Esc><Cmd>ToggleTerm<CR>";
      options.desc = "Toggle terminal";
    }
    {
      mode = "t";
      key = "<Esc><Esc>";
      action = "<C-\\><C-n>";
      options.desc = "Switch to normal mode";
    }
    {
      mode = [ "n" "t" ];
      key = "<Leader>tn";
      action.__raw = ''
        function()
          local curterm = require("toggleterm.terminal").get_focused_id()

          if curterm ~= nil then
            vim.cmd(curterm .. "ToggleTermSetName")
          end
        end
        '';
      options.desc = "Rename current terminal";
    }
    {
      mode = [ "n" "t" ];
      key = "<Leader>tl";
      action = "<cmd>TermSelect<cr>";
      options.desc = "List terminals";
    }

  ];
  extraConfigLua = ''
    vim.opt.conceallevel = 2
    vim.opt.concealcursor = 'nc'

    --   require('telekasten').setup({
    -- home = vim.fn.expand("~/Downloads/obsidian"), -- Put the name of your notes directory here
    -- })
    -- require("neorg").setup({
    --   load = {
    --     ["core.defaults"] = {},
    --     ["core.concealer"] = {
    --       config = { -- We added a `config` table!
    --         icon_preset = "varied", -- And we set our option here.
    --       },
    --     },
    --   }
    -- })
    '';
}
