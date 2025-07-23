{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, home-manager, stylix, hyprland, nixvim, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true; # Allow unfree packages globally
          # Alternatively, allow only specific packages:
          # allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) ["cnijfilter2"];
        };
      };
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };

        modules = [
          ./configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.guoyi = import ./home.nix;
              extraSpecialArgs = { inherit inputs pkgs; };
            };
          }

          stylix.nixosModules.stylix

          # Hyprland   
          hyprland.nixosModules.default
          {
            programs.hyprland = {
              enable = true;
              package = inputs.hyprland.packages.${system}.default;
            };
          }

          # Nix     
          ({ config, lib, ... }: {
            # nix = {
            #   package = pkgs.nixVersions.stable;
            #   settings = {
            #     experimental-features = [ "nix-command" "flakes" ];
            #     auto-optimise-store = true;
            #     trusted-users = [ "root" "guoyi" ];
            #   };
            #   gc = {
            #     automatic = true;
            #     dates = "weekly";
            #     options = "--delete-older-than 3d";
            #   };
            nixpkgs.pkgs = pkgs; # 使用预先配置好的 pkgs
            # imports = [
            #   # "${nixpkgs}/nixos/modules/misc/nixpkgs/read-only.nix"
            #   # 或者使用 flake 方式：
            #   nixpkgs.nixosModules.readOnlyPkgs
            # ];
          })
        ];
      };
    };
}
