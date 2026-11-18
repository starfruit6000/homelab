{ pkgs ? import <nixpkgs> { }, development ? false }:

pkgs.mkShell {
  packages = with pkgs; [
    age ansible fluxcd kubectl kubernetes-helm kustomize opentofu sops
  ] ++ pkgs.lib.optionals development [
    pkgs.nixos-build-vms
  ];
}
