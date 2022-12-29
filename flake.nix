{
  description = "A bunch of home-manager modules";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";

    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }: let
    mkHomeManagerModule = { user, imports }: { config, ... }: {
      imports = [
        (home-manager.nixosModules.home-manager)
      ];
      home-manager = {
        # This is needed to make sure that home-manager follows the
        # pkgs/nixpkgs specified in this flake.
        #
        # Relevant github issue: https://github.com/divnix/devos/issues/30
        useGlobalPkgs = true;
        useUserPackages = true;
      };
      home-manager.users."${user}" = {
        inherit imports;
      };
    }; in {
      nixosModules.chao-home = mkHomeManagerModule {
        user = "chao";
        imports = [ ./by-user/chao ];
      };
    };
}
