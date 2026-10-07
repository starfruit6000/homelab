## GNOME Keyring state passphrase

OpenTofu reads the state encryption passphrase from GNOME Keyring through its
external key provider. Store it once:

```sh
secret-tool store \
  --label='Homelab Grafana Cloud OpenTofu state passphrase' \
  service opentofu account homelab-grafana-cloud-state
```

GNOME login keyring must be unlocked when running OpenTofu.

The HTTP backend is declared in `providers.tf`; `glab opentofu init` supplies the GitLab project, state name, and authentication:

```sh
glab opentofu init grafana-cloud -- -reconfigure
tofu plan
tofu apply
```
