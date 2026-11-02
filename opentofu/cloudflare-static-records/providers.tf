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
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.28.1"
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

provider "sops" {}

data "sops_file" "secrets" {
  source_file = "../../sops/opentofu-secrets/cloudflare-static-records-secrets.enc.yaml"
}

provider "cloudflare" {
  api_token = data.sops_file.secrets.data["cloudflare_api_token"]
}
