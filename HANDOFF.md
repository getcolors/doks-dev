# DOKS development cluster handoff

## Current status: shut down

The cluster was deleted through the pinned Green workflow on 2026-09-15 after
Redis and the controller volume were cleaned up. DigitalOcean API checks verified
that cluster `a87775cd-de9f-4390-8dee-281f864bc9de`, worker `600715804`, and both
cluster firewalls are absent. The `doks-state` R2 bucket remains accessible.
The registry and its subscription were also removed by the deployment shutdown.
The details below record the earlier live test.

## Deployment

- Cluster: `colors-doks-dev-20260915`
- DigitalOcean cluster ID: `a87775cd-de9f-4390-8dee-281f864bc9de`
- Region/version: `ams3`, `1.36.3-do.5`
- Worker pool: one `s-2vcpu-4gb` worker
- Worker: `colors-doks-dev-20260915-workers-3fig5l`, Droplet `600715804`
- Worker public/private IP: `209.38.46.78` / `10.133.0.3`
- State: R2 `doks-state`, key `doks-dev/cluster.tfstate`, native S3 lockfile
- Context: `do-ams3-colors-doks-dev-20260915`
- Private kubeconfig: `.colors/doks-dev/cluster/kubeconfig` (0600, expires after 24 hours)

The cluster is dedicated to this task. The DOKS package owns the cluster and its
worker pool only. Redis infrastructure and the container registry have separate
lifecycles. The cluster and worker were billable while provisioned; both have now been deleted.

## Verification

The upstream package passed three offline tests with 12 assertions. The pinned
launcher passed credential-free build and create dry-run. A protected delete
was rejected before provider access. Live `./green create` completed successfully,
followed by a passing pinned `./green check`. Remote state was saved and its lock
released. Live API kubeconfig acquisition and
Kubernetes API access succeeded. `kubectl wait --for=condition=Ready nodes
--all --timeout=300s` passed; the worker runs Kubernetes v1.36.3.

## Operations

Load the three credentials documented in README privately, then run:

```sh
./green check
./green kubeconfig
export KUBECONFIG="$PWD/.colors/doks-dev/cluster/kubeconfig"
kubectl get nodes -o wide
```

The bootstrap workflow runs on your machine. OpenTofu state locking coordinates
its mutations; do not bypass locks or move the state key. Create blocks destructive
replacement of the existing cluster, including when the package delete flag has
been overridden. Explicit delete alone renders a destroyable resource.

Before cluster cleanup, remove or deliberately retain Redis infrastructure using
its operator while that operator still runs. Then:

```sh
COLORS_PAR_COMPUTE_PREVENT_DESTROY=false ./green delete
```

Deleting DOKS does not delete the separate Redis Droplet, registry, or R2 buckets.
Never identify a Droplet for the Redis fault test by region or creation time:
exclude the DOKS worker and prove the Redis resource's ownership first.
