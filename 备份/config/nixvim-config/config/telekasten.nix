{ pkgs, ... }:

{
  extraPlugins = with pkgs.vimPlugins; [
    telekasten-nvim
  ];
}
