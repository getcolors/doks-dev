# doks-dev handoff

## Current status: shut down

Created, checked and deleted on 2026-09-16 through the `doks` Package Skill
(pin `d246db4`). The previous, hand-rolled deployment is under
[history/2026-09-15/](history/2026-09-15/). The full account of the day, the
evidence and the open items live in
[redis-operator-doks/HANDOFF.md](https://github.com/getcolors/redis-operator-doks/blob/main/HANDOFF.md).

## The deployment that ran

- Cluster `doks-dev`, ID `2e927b38-90a5-4d73-98af-d974f9fe9fd1`, `ams3`,
  `1.36.3-do.5`, one `s-2vcpu-4gb` worker `doks-dev-3fd5ld`
  (Droplet `600945297`, `134.209.92.109`); kube context `do-ams3-doks-dev`.
- Registry `registry.digitalocean.com/doks-dev` (basic tier), integrated with
  the cluster; DOKS injected the pull Secret `doks-dev` into `colors-redis`.
- State in `doks-state`: `doks-dev/compute/managed-kubernetes.tfstate` and
  `doks-dev/registry.tfstate`, both on the library's R2 backend with the
  native lockfile. The old `doks-dev/cluster.tfstate` (zero resources) was
  removed before the first create.
- `create` 6 min 16 s; second `create` a 13 s no-op; `check` printed the Ready
  node and its external IP plus the registry integration; `kubeconfig` and
  `registry` wrote `0600` files under `.colors/doks-dev/`.

## Shutdown

`COLORS_PAR_COMPUTE_PREVENT_DESTROY=false ./green delete` on 2026-09-16 at
about 08:10 UTC: registry integration removed, cluster destroyed, registry
destroyed. DigitalOcean deleted the worker Droplet and the two cluster
firewalls asynchronously about four minutes later; the account then held no
Droplets, clusters, firewalls or registry. The package's last cleanup step
failed on the non-empty `.colors/doks-dev/registry/push/` directory after all
destruction had completed; see the redis-operator-doks handoff for the fix.
`doks-state` keeps the two retired state objects.

The cleanup failure was a root-owned `registry/push/buildx/` subtree left by
the image build (docker ran as root with that directory as its config). The
`doks` package now reports leftovers instead of throwing, prints one line per
delete stage, and `redis-operator/scripts/image.sh` builds from a private
temp config directory. After removing the leftover by hand and refreshing the
payload to pin `41e12fc`, a second `delete` on the already-destroyed
deployment completed all stages and the cleanup, leaving only the rendered
documents under `.colors/doks-dev/`.
