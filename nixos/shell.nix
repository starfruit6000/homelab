{ pkgs ? import <nixpkgs> { }, platform ? false }:

pkgs.mkShell {
  packages = with pkgs; [
    age ansible fluxcd kubectl kubernetes-helm kustomize opentofu sops
  ] ++ pkgs.lib.optionals platform [
    pkgs.nixos-build-vms
  ];
}
