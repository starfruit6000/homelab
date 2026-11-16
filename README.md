# Homelab

## Devcontainers

From the repository root, using the Dev Container CLI:

```sh
# Production maintenance (default)
devcontainer --docker-path podman up --workspace-folder .

# Platform development
devcontainer --docker-path podman up --workspace-folder . --config .devcontainer/platform/devcontainer.json
```

## Development VMs

In the platform devcontainer, from the repository root:

```sh
nix-shell nixos/shell.nix --arg platform true
nixos-build-vms nixos/network.nix
./result/bin/nixos-run-vms
```

## How to set up

1. Configure Cloudflare DNS records
2. Configure Mikrotik router
3. Prepare preseeded ISO
4. Install the system
5. Configure the host with Ansible
6. FluxCD Operator takes after
