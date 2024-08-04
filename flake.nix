{
  description = "NixOS and home-manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    templ = {
      url = "github:a-h/templ";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xc = {
      url = "github:joerdav/xc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , ...
    }@ inputs:
    let
      inherit (self) outputs;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      # My public SSH key:
      sshkey = ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC4ZYYVVw4dsNtzOnBCTXbjuRqOowMOvP3zetYXeE5i+2Strt1K4vAw37nrIwx3JsSghxq1Qrg9ra0aFJbwtaN3119RR0TaHpatc6TJCtwuXwkIGtwHf0/HTt6AH8WOt7RFCNbH3FuoJ1oOqx6LZOqdhUjAlWRDv6XH9aTnsEk8zf+1m30SQrG8Vcclj1CTFMAa+o6BgGdHoextOhGMlTx8ESAlgIXCo+dIVjANE2qbfAg0XL0+BpwlRDJt5OcgzrILXZ1jSIYRW4eg/JBcDW/WqorEummxhB26Y6R0jeswRF3DOQhU2fAhbsCWdairLam42rFGlKfWyTbgjRXl/BNR'';
      rootSSHKey = ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOjt4N/HZ+dOEJ62OunmT0ZF2SqsT96iUdfSi6ZP83wt root@adrian.local'';

      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      # Custom packages: accessible through 'nix build', 'nix shell', etc.
      packages = forAllSystems (system: import ./pkgs { pkgs = nixpkgs.legacyPackages.${system}; inherit inputs; });

      # Exported overlays. Includes custom packages and flake outputs.
      overlays = import ./overlays { inherit inputs; };

      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      nixosConfigurations = {
        builder-x86_64 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            adrianSSHKey = sshkey;
            rootSSHKey = rootSSHKey;
          };
          modules = [
            ./systems/builder/config.nix
          ];
        };
        builder-aarch64 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            adrianSSHKey = sshkey;
            rootSSHKey = rootSSHKey;
          };
          modules = [
            ./systems/builder/config.nix
          ];
        };
        burner = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs sshkey; };
          modules = [
            ./systems/burner/config.nix
            ./systems/burner/hardware.nix
          ];
        };
      };

      homeConfigurations = {
        "adrian@burner" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./systems/edward-laptop-01/users/adrian.nix ];
        };
      };
    };
}
