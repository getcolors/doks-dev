# Development DOKS cluster

One ams3 worker runs the Redis operator. Redis itself runs on a separate Droplet.
This repository pins the DOKS package; Green and provider pins live upstream.

Load credentials privately through direnv or the workspace .envrc.private, then:

```sh
./green build
./green create --dry-run
./green create
./green check
export KUBECONFIG="$PWD/.colors/doks-dev/cluster/kubeconfig"
kubectl get nodes
```

`./green kubeconfig` refreshes the private, 24-hour kubeconfig. The dedicated
`doks-state` R2 bucket stores `doks-dev/cluster.tfstate` and its lockfile. Required
credentials are COLORS_PAR_DO_TOKEN, COLORS_PAR_DOKS_STATE_R2_ACCESS_KEY_ID, and
COLORS_PAR_DOKS_STATE_R2_SECRET_ACCESS_KEY. Never export COLORS_PAR_PROFILE.

The cluster and worker are billable. Clean up Redis through its own operator
first; cluster deletion cannot clean external resources after that operator stops.
Then explicitly run `COLORS_PAR_COMPUTE_PREVENT_DESTROY=false ./green delete`.
This package owns no container registry or load balancer.
