function rs
    cd ~/nix & git add . & git commit -m 'commit by fish' & git push & sudo nix flake lock --update-input nixvim && sudo nixos-rebuild switch  --flake .#nixos 
end

function lg
  lazygit
end

function v
  nvim
end

