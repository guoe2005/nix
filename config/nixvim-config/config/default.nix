{
  imports = [
    ./keymaps.nix
    ./lsp/default.nix
    ./lsp/fidget.nix
    ./lsp/ionide.nix
    ./lsp/none-ls.nix
    ./lsp/trouble.nix
    ./utils/auto-pairs.nix
    ./utils/autosave.nix
    ./utils/blankline.nix
    ./utils/telescope.nix
    ./utils/toggleterm.nix
    ./utils/which-key.nix
    ./utils/wilder.nix
    ./bufferline.nix
    ./cmp.nix
    ./git.nix
    ./notify.nix
    # ./markview.nix
    ./options.nix
    ./treesitter.nix
    ./lightline.nix
    ./lazygit.nix
    ./neo-tree.nix
    # ./neorg.nix
    ./obsidian.nix
    # ./nvim-tree.nix
    ./plenary.nix
    # ./telekasten.nix
    ./vim-bbye.nix
    # ./lightline-bufferline.nix
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
  '';

   extraConfigLua = ''
    vim.opt.conceallevel = 1

    -- require('telekasten').setup({
    --   home = vim.fn.expand("~/Downloads/obsidian"), -- Put the name of your notes directory here
    -- })
    -- Launch panel if nothing is typed after <leader>z
    -- vim.keymap.set("n", "<leader>z", "<cmd>Telekasten panel<CR>")
    -- -- Most used functions
    -- vim.keymap.set("n", "<leader>zf", "<cmd>Telekasten find_notes<CR>")
    -- vim.keymap.set("n", "<leader>zg", "<cmd>Telekasten search_notes<CR>")
    -- vim.keymap.set("n", "<leader>zd", "<cmd>Telekasten goto_today<CR>")
    -- vim.keymap.set("n", "<leader>zz", "<cmd>Telekasten follow_link<CR>")
    -- vim.keymap.set("n", "<leader>zn", "<cmd>Telekasten new_note<CR>")
    -- vim.keymap.set("n", "<leader>zc", "<cmd>Telekasten show_calendar<CR>")
    -- vim.keymap.set("n", "<leader>zb", "<cmd>Telekasten show_backlinks<CR>")
    -- vim.keymap.set("n", "<leader>zI", "<cmd>Telekasten insert_img_link<CR>")
    -- -- Call insert link automatically when we start typing a link
    -- vim.keymap.set("i", "[[", "<cmd>Telekasten insert_link<CR>")
    '';
}
