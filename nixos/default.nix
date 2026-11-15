{ system ? "x86_64-linux", nixpkgs ? <nixpkgs> }:

let
  pkgs = import nixpkgs { inherit system; };
  mkHost = host: modules: import "${nixpkgs}/nixos/lib/eval-config.nix" {
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
in rec {
  nixosConfigurations = {
    dogs = mkHost "dogs" [ ./production.nix (hardware "dogs") ];
    echoes = mkHost "echoes" [ ./production.nix (hardware "echoes") ];
  };
  tools = pkgs.buildEnv {
    name = "homelab-tools";
    paths = with pkgs; [
      age ansible fluxcd kubectl kubernetes-helm kustomize opentofu sops
    ];
  };
  platform-tools = pkgs.buildEnv {
    name = "homelab-platform-tools";
    paths = [ tools pkgs.nixos-build-vms ];
  };
}
