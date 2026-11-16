{
  networking.hostName = "dogs";
  services.rke2.extraFlags = [
    "--tls-san=animals"
    "--tls-san=dogs.home.parents-basement.win"
  ];
}
