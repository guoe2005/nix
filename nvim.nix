{inputs, ...}: let
  pkgs = import inputs.nixpkgs-unstable {};
in {
  home.packages = with pkgs; [
    neovim
  ];

  # home.file."./.config/nvim/" = {
  #   source = ./config;
  #   recursive = true;
  # };
}
