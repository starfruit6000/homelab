# Homelab

## Devcontainers

### Platform maintenance devcontainer
```sh
devcontainer --docker-path podman up --workspace-folder . --id-label "homelab.workspace=$PWD" --id-label homelab.role=maintenance
devcontainer exec --docker-path podman --workspace-folder . --id-label "homelab.workspace=$PWD" --id-label homelab.role=maintenance bash
```

### Development devcontainer

```sh
devcontainer --docker-path podman up --workspace-folder . --config .devcontainer/development/devcontainer.json --mount-git-worktree-common-dir --id-label "homelab.workspace=$PWD" --id-label homelab.role=development
devcontainer exec --docker-path podman --workspace-folder . --config .devcontainer/development/devcontainer.json --mount-git-worktree-common-dir --id-label "homelab.workspace=$PWD" --id-label homelab.role=development bash
nix-shell nixos/shell.nix --arg development true
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
