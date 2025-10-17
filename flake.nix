{
  description = "A sample NixOS-on-Lima configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-lima = {
      url = "github:nixos-lima/nixos-lima/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-lima, home-manager, ... }@inputs:
    let
      # Change this to "x86_64-linux" if necessary
      system = "aarch64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
        nixosConfigurations.emilkje-aarch64 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          # Pass the `nixos-lima` input along with the default module system parameters
          specialArgs = { inherit nixos-lima; };
          modules = [
            ./configuration.nix
          ];
        };
        nixosConfigurations.emilkje-x86_64 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          # Pass the `nixos-lima` input along with the default module system parameters
          specialArgs = { inherit nixos-lima; };
          modules = [
            ./configuration.nix
          ];
        };

        # You'll need to change the configuration name to match the username
        # that Lima automatically creates (same as your host username)
        homeConfigurations."emilkje" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [
            {
               home.username = "emilkje";
               home.homeDirectory = "/home/emilkje.linux";
               home.stateVersion = "25.05";
               programs.git.userEmail = "emilkje@gmail.com";
               programs.git.userName  = "Emil Kjelsrud";
            }
            ./home.nix
          ];

          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
        };
    };    
}
