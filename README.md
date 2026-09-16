# doks-dev

Desired state for one development DOKS cluster in `ams3`, one `s-2vcpu-4gb`
worker, named `doks-dev` after the profile, plus the deployment-owned basic-tier
container registry `doks-dev` integrated with the cluster. The sibling
[`redis-operator-doks`](https://github.com/getcolors/redis-operator-doks)
deployment runs its controller here and publishes its image to that registry.

This repository installs the [`doks`](https://github.com/getcolors/doks) Package
Skill in Green, Red and Blue. `colors.yml` is the only desired-state file to edit.
Use `./red` or `./blue` in place of `./green` for the same verbs and state.

```sh
direnv allow                 # once; loads devenv and the private credentials
./green build                # render .colors/doks-dev/ — no provider calls
./green create --dry-run     # walk the graph, skip every side effect
./green create               # converge cluster, registry, integration
./green check                # nodes Ready, node external IPs, registry integrated
./green kubeconfig           # re-materialize .colors/doks-dev/kubeconfig (0600)
./green registry             # one-hour push credentials under .colors/doks-dev/registry/push/
COLORS_PAR_COMPUTE_PREVENT_DESTROY=false ./green delete
```

Credentials live only in the gitignored `.envrc.private`: `COLORS_PAR_DO_TOKEN`
and the `COLORS_PAR_R2_*` pair for the `doks-state` bucket, which holds
`doks-dev/compute/managed-kubernetes.tfstate` and `doks-dev/registry.tfstate`.
Never export `COLORS_PAR_PROFILE`.

The cluster, its worker and the registry are billable. Delete the Redis operator
deployment first; deleting the cluster cannot clean the Droplet the operator
manages. See `HANDOFF.md` for the latest verified state and
`history/2026-09-15/` for the previous, hand-rolled deployment.
