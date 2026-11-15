# Homelab

## Devcontainers

The default devcontainer is **Homelab - production maintenance**. To select
**Homelab - platform development** with the Dev Container CLI, run:

```sh
devcontainer --docker-path podman up --workspace-folder . --config .devcontainer/platform/devcontainer.json
```

Both provide Ansible, OpenTofu, kubectl, Helm, Flux, SOPS and age. The
maintenance container does not start a cluster or automatically mount
production credentials; provide those separately.

The platform container does not start VMs automatically. To run a NixOS/RKE2 VM
manually, use Nix's VM runner from the repository root:

```sh
nix-build ./nixos -A dogs-vm -o /tmp/homelab-dogs-vm
/tmp/homelab-dogs-vm/bin/run-dogs-vm
```

The configuration uses the configured `<nixpkgs>` channel. Its Nixpkgs version
must provide the NixOS RKE2 module and `rke2_1_37`; it is not pinned here.

Use `echoes-vm` and `run-echoes-vm` for the other host. Each VM uses its corresponding repository
host configuration plus `nixos/vm.nix` for virtual hardware and console access.
The VM runs in the foreground and logs in as root on its console; inside it, use
`kubectl --kubeconfig /etc/rancher/rke2/rke2.yaml get nodes`. Shut it down from
the guest with `poweroff`. The runner creates a disk image in the current
directory; it survives container restarts if the workspace is persistent.

Each VM requires an x86-64 Linux container, internet access, 4 GiB RAM and disk
space for Nix, the VM and Kubernetes images. QEMU can fall back to much slower
software emulation. The VMs do not bootstrap Flux or production secrets and do
not export kubeconfigs to the devcontainer.

## NixOS migration

`nixos/default.nix` exposes `nixosConfigurations.dogs` and `nixosConfigurations.echoes`;
both use the same host and RKE2 modules as the development VMs. These definitions
are **not yet production-ready**: hardware and boot configuration, storage,
secrets, Flux bootstrap and the remaining Ansible roles still need to be migrated
and verified. Before building a production host, generate its hardware module
on that host with `nixos-generate-config --show-hardware-config` and add it as
`nixos/hosts/dogs-hardware.nix` or `nixos/hosts/echoes-hardware.nix`. Do not
deploy these definitions to existing clusters until the migration is complete.
`nixos/production.nix` deliberately blocks production builds until the remaining
work is finished. The shared configuration currently disables the NixOS firewall;
network policy must also be reviewed before removing that guard.

## How to set up

1. Configure Cloudflare DNS records
2. Configure Mikrotik router
3. Prepare preseeded ISO
4. Install the system
5. Configure the host with Ansible
6. FluxCD Operator takes after
