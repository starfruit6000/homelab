{
  networking.hostName = "echoes";
  services.rke2.extraFlags = [
    "--tls-san=meddle"
    "--tls-san=echoes.home.parents-basement.win"
  ];
}
