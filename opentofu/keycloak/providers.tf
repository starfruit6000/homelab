terraform {
  backend "http" {}
  encryption {
    key_provider "pbkdf2" "this" {
      passphrase = var.state_passphrase
    }
    method "aes_gcm" "this" {
      keys = key_provider.pbkdf2.this
    }
    state {
      method   = method.aes_gcm.this
      enforced = true
    }
    plan {
      method   = method.aes_gcm.this
      enforced = true
    }
  }
  required_providers {
    keycloak = {
      source  = "keycloak/keycloak"
      version = "5.10.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.2.1"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.4.1"
    }
  }
}

variable "state_passphrase" {
  type      = string
  sensitive = true
}

provider "kubernetes" {
  config_path = "../../sops/${var.cluster_name}/kube_config"
}

provider "keycloak" {
  client_id                = var.use_bootstrap ? "bootstrap" : "terraform"
  client_secret            = var.use_bootstrap ? data.kubernetes_secret_v1.terraform_bootstrap.data["client-secret"] : data.kubernetes_secret_v1.terraform_admin.data["client-secret"]
  url                      = "https://keycloak${local.route_suffix}.${local.homelab_internal_subdomain}"
  realm                    = "master"
  tls_insecure_skip_verify = var.is_local
}

provider "sops" {}

data "sops_file" "keycloak_secrets" {
  source_file = "../../sops/${var.cluster_name}/keycloak-opentofu.enc.yaml"
}
