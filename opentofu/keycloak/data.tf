data "kubernetes_secret_v1" "terraform_bootstrap" {
  metadata {
    name      = "bootstrap"
    namespace = "keycloak"
  }
}

data "kubernetes_secret_v1" "terraform_admin" {
  metadata {
    name      = "terraform"
    namespace = "keycloak"
  }
}

data "kubernetes_config_map_v1" "flux_runtime_info" {
  metadata {
    name      = "flux-runtime-info"
    namespace = "keycloak"
  }
}
