{
  description = "Homelab NixOS hosts and maintenance tools";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/d4f25a3e562008648d45bcf2d70bcc7422cad84e";

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      mkHost = host: modules: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          (./hosts + "/${host}.nix")
        ] ++ modules;
      };
      hardware = host:
        let path = ./hosts + "/${host}-hardware.nix";
        in if builtins.pathExists path then path else {
          assertions = [{
            assertion = false;
            message = "Generate and add nixos/hosts/${host}-hardware.nix before deploying this host.";
          }];
        };
      vm = host: context: port: mkHost host [
        "${nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
        ./vm.nix
        { _module.args = { localContext = context; localPort = port; };
          virtualisation.forwardPorts = [{
            host.address = "127.0.0.1";
            host.port = port;
            guest.port = 6443;
          }];
        }
      ];
    in {
      nixosConfigurations = {
        dogs = mkHost "dogs" [ ./production.nix (hardware "dogs") ];
        echoes = mkHost "echoes" [ ./production.nix (hardware "echoes") ];
      };
      packages.${system} = {
        tools = pkgs.buildEnv {
          name = "homelab-tools";
          paths = with pkgs; [
            age ansible fluxcd kubectl kubernetes-helm kustomize opentofu sops
          ];
        };
        dogs-vm = (vm "dogs" "animals-local" 16443).config.system.build.vm;
        echoes-vm = (vm "echoes" "meddle-local" 26443).config.system.build.vm;
      };
    };
}
