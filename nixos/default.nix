{ system ? "x86_64-linux", nixpkgs ? <nixpkgs> }:

let
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
in {
  nixosConfigurations = {
    dogs = mkHost "dogs" [ ./production.nix (hardware "dogs") ];
    echoes = mkHost "echoes" [ ./production.nix (hardware "echoes") ];
  };
}
