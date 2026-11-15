{ lib, pkgs, ... }:
{
  virtualisation = {
    memorySize = 4096;
    cores = 2;
    diskSize = 32768;
    graphics = false;
    useNixStoreImage = true;
    sharedDirectories = lib.mkForce { };
  };

  services.getty.autologinUser = "root";
  environment.systemPackages = [ pkgs.kubectl ];
}
