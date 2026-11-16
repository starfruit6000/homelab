{ pkgs, ... }:
{
  system.stateVersion = "25.11";
  networking.firewall.enable = false;

  services.rke2 = {
    enable = true;
    role = "server";
    package = pkgs.rke2_1_37;
    cni = "cilium";
    disable = [ "rke2-ingress-nginx" ];
    extraFlags = [ "--disable-kube-proxy" ];
    manifests.cilium.content = {
      apiVersion = "helm.cattle.io/v1";
      kind = "HelmChartConfig";
      metadata = {
        name = "rke2-cilium";
        namespace = "kube-system";
      };
      spec.valuesContent = builtins.toJSON {
        hubble = {
          enabled = true;
          relay.enabled = true;
          ui.enabled = true;
        };
        kubeProxyReplacement = true;
        k8sServiceHost = "localhost";
        k8sServicePort = "6443";
        l2announcements.enabled = true;
        k8sClientRateLimit = {
          qps = 15;
          burst = 30;
        };
      };
    };
  };
}
