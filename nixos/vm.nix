{ lib, pkgs, localContext, localPort, ... }:
let
  kubeconfigExpression = lib.concatStringsSep " | " [
    ''(.clusters[].name) = "${localContext}"''
    ''(.clusters[].cluster.server) = "https://127.0.0.1:${toString localPort}"''
    ''(.users[].name) = "${localContext}"''
    ''(.contexts[].name) = "${localContext}"''
    ''(.contexts[].context.cluster) = "${localContext}"''
    ''(.contexts[].context.user) = "${localContext}"''
    ''."current-context" = "${localContext}"''
  ];
in
{
  virtualisation = {
    memorySize = 4096;
    cores = 2;
    diskSize = 32768;
    graphics = false;
    useNixStoreImage = true;
    sharedDirectories = lib.mkForce { };
    fileSystems."/mnt/exchange" = {
      device = "exchange";
      fsType = "9p";
      neededForBoot = true;
      options = [ "trans=virtio" "version=9p2000.L" ];
    };
  };

  boot.initrd.availableKernelModules = [ "9p" "9pnet_virtio" ];
  systemd.services.export-kubeconfig = {
    description = "Export the local RKE2 kubeconfig to the devcontainer";
    after = [ "rke2-server.service" ];
    requires = [ "rke2-server.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.coreutils}/bin/install -m 600 /etc/rancher/rke2/rke2.yaml /mnt/exchange/kubeconfig.tmp";
      ExecStartPost = [
        "${pkgs.yq-go}/bin/yq eval -i ${lib.escapeShellArg kubeconfigExpression} /mnt/exchange/kubeconfig.tmp"
        "${pkgs.coreutils}/bin/mv /mnt/exchange/kubeconfig.tmp /mnt/exchange/kubeconfig"
      ];
    };
  };
}
