
{ pkgs, ... }:

{
  extraPlugins = with pkgs.vimPlugins; [
    fcitx-vim
  ];
}
