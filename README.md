# Homelab

## Devcontainers

Choose **Homelab - production maintenance** or **Homelab - platform development**
when opening the repository in a devcontainer. Both provide Ansible, OpenTofu,
kubectl, Helm, Flux, SOPS and age. The maintenance container does not start a
cluster or automatically mount production credentials; provide those separately.

The platform container automatically builds and starts two independent single-node NixOS/RKE2
VMs from the repository's `dogs` and `echoes` host configurations. The only
additional module, `nixos/vm.nix`, supplies VM hardware and kubeconfig export.
The local contexts are `animals-local` and `meddle-local`. Its default
`KUBECONFIG` contains only these local clusters. Use `kubectl config use-context
animals-local` or `kubectl config use-context meddle-local` to switch. VM disks,
kubeconfigs and console logs live under `~/.local/state/homelab` in the container.
They survive container restarts, but not a devcontainer rebuild.

This requires an x86-64 Linux container, internet access, at least 8 GiB RAM for
the VMs in addition to the container, and sufficient disk space for Nix, VM
images and Kubernetes images. The first build and cluster startup can take a
long time; the VMs start in the background. Use `supervisorctl -c
/etc/homelab-supervisord.conf status` and `kubectl get nodes` to check progress.
QEMU can fall back to software emulation, which is much slower. If startup fails,
inspect the corresponding `console.log`; the local kubeconfigs contain cluster-admin
credentials and should not be shared. The local VMs do not bootstrap Flux or
production secrets automatically. Their APIs are reachable from the devcontainer;
the VMs use separate NAT networks and cannot directly reach each other.
Restart a VM with `supervisorctl -c /etc/homelab-supervisord.conf restart dogs`
or `restart echoes` to rebuild it after changing its NixOS configuration.

## NixOS migration

`nixos/flake.nix` exposes `nixosConfigurations.dogs` and `nixosConfigurations.echoes`;
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
