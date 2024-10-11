function rs
   cd ~/nix && sudo nix flake lock --update-input nixvim && sudo nixos-rebuild switch  --flake .#surface 
end

function rt
   cd ~/nix && sudo nix flake lock --update-input nixvim && sudo nixos-rebuild switch  --flake .#t440 
end
