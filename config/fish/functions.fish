function rs
    cd ~/nix & sudo nix flake lock --update-input nixvim && sudo nixos-rebuild switch  --flake .#nixos 
end

function lg
  lazygit
end

function v
  nvim
end

