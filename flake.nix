{
  inputs = {
    nix.url = "github:nixos/nix/2.24.10";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nix-serve-ng = {
      url = "github:aristanetworks/nix-serve-ng";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nix, nix-serve-ng, ... }@inputs:
    let
      adrianSSHKey = ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC4ZYYVVw4dsNtzOnBCTXbjuRqOowMOvP3zetYXeE5i+2Strt1K4vAw37nrIwx3JsSghxq1Qrg9ra0aFJbwtaN3119RR0TaHpatc6TJCtwuXwkIGtwHf0/HTt6AH8WOt7RFCNbH3FuoJ1oOqx6LZOqdhUjAlWRDv6XH9aTnsEk8zf+1m30SQrG8Vcclj1CTFMAa+o6BgGdHoextOhGMlTx8ESAlgIXCo+dIVjANE2qbfAg0XL0+BpwlRDJt5OcgzrILXZ1jSIYRW4eg/JBcDW/WqorEummxhB26Y6R0jeswRF3DOQhU2fAhbsCWdairLam42rFGlKfWyTbgjRXl/BNR'';
      rootSSHKey = ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOjt4N/HZ+dOEJ62OunmT0ZF2SqsT96iUdfSi6ZP83wt root@adrian.local'';
      allSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
        "aarch64-linux" # 64-bit ARM Linux
        "x86_64-darwin" # 64-bit Intel macOS
        "aarch64-darwin" # 64-bit ARM macOS
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        inherit system;
        pkgs = import nixpkgs {
          inherit system;
        };
      });
      devTools = { system, pkgs }: [
        pkgs.minio-client
      ];
    in
    {
      devShells = forAllSystems ({ system, pkgs }: {
        default = pkgs.mkShell {
          buildInputs = (devTools { system = system; pkgs = pkgs; });
        };
      });
      nixosConfigurations = {
        hetzner-builder-x86_64 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            adrianSSHKey = adrianSSHKey;
            rootSSHKey = rootSSHKey;
          };
          modules = [
            nix-serve-ng.nixosModules.default
            ./systems/hetzner/builder/config.nix
            {
              imports = [ "${nixpkgs}/nixos/modules/profiles/hardened.nix" ];
            }
          ];
        };
        hetzner-dedicated-x86_64 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            system = "x86_64-linux";
            adrianSSHKey = adrianSSHKey;
            rootSSHKey = rootSSHKey;
            inputs = inputs;
          };
          modules = [
            ./systems/hetzner/dedicated/config.nix
          ];
        };
        builder-x86_64 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            adrianSSHKey = adrianSSHKey;
            rootSSHKey = rootSSHKey;
          };
          modules = [
            ./systems/utm/builder/config.nix
          ];
        };
        builder-aarch64 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            adrianSSHKey = adrianSSHKey;
            rootSSHKey = rootSSHKey;
          };
          modules = [
            ./systems/utm/builder/config.nix
          ];
        };
      };
    };
}
