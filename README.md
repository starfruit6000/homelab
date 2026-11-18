# Homelab

## Devcontainers

```sh
# Production maintenance: start and open a shell
devcontainer --docker-path podman up --workspace-folder . --id-label "homelab.workspace=$PWD" --id-label homelab.role=maintenance
devcontainer exec --docker-path podman --workspace-folder . --id-label "homelab.workspace=$PWD" --id-label homelab.role=maintenance bash

# Platform development: after exiting the maintenance shell, start and open a shell
devcontainer --docker-path podman up --workspace-folder . --config .devcontainer/platform/devcontainer.json --id-label "homelab.workspace=$PWD" --id-label homelab.role=platform
devcontainer exec --docker-path podman --workspace-folder . --config .devcontainer/platform/devcontainer.json --id-label "homelab.workspace=$PWD" --id-label homelab.role=platform bash

# Inside the platform container: start the VMs
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
