{ config, pkgs, ... }:
{
  virtualisation = {
    memorySize = 4096;
    cores = 2;
    diskSize = 32768;
    graphics = false;
    vlans = [ 1 ];
  };

  networking.interfaces.eth0.useDHCP = true;
  networking.defaultGateway = {
    address = "10.0.2.2";
    interface = "eth0";
  };
  networking.nameservers = [ "10.0.2.3" ];
  services.rke2.extraFlags = [ "--node-ip=${config.networking.primaryIPAddress}" ];
  environment.systemPackages = [ pkgs.kubectl ];
}
