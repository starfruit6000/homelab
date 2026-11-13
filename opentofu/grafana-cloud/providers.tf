terraform {
  backend "http" {}
  encryption {
    key_provider "external" "keyring" {
      command = [
        "bash",
        "-o", "pipefail",
        "-c", <<-EOT
          set -euo pipefail
          printf '%s\n' '{"magic":"OpenTofu-External-Key-Provider","version":1}'
          cat >/dev/null
          key="$(secret-tool lookup service opentofu account homelab-grafana-cloud-state | tr -d '\n' | base64 -w0)"
          test -n "$key"
          printf '{"keys":{"encryption_key":"%s","decryption_key":"%s"},"meta":{"external_data":{}}}' "$key" "$key"
        EOT
      ]
    }
    key_provider "pbkdf2" "this" {
      chain = key_provider.external.keyring
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
    grafana = {
      source  = "grafana/grafana"
      version = "4.55.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.4.1"
    }
  }
}

provider "sops" {}

data "sops_file" "grafana_secrets" {
  source_file = "../../sops/opentofu-secrets/secrets.enc.yaml"
}

provider "grafana" {
  url  = var.grafana_url
  auth = data.sops_file.grafana_secrets.data["grafana_auth"]
}
