locals {
  homelab_internal_subdomain = data.kubernetes_config_map_v1.flux_runtime_info.data["HOMELAB_INTERNAL_SUBDOMAIN"]
  route_suffix               = data.kubernetes_config_map_v1.flux_runtime_info.data["ROUTE_SUFFIX"]
}
