function rs
   cd ~/nix && sudo nix flake lock --update-input nixvim && sudo nixos-rebuild switch  --flake .#nixos --impure
end

function lg
  lazygit
end
