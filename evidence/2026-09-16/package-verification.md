# Live DOKS port verification

Verified on 2026-09-16 against DigitalOcean in ams3.

The initial Green check reported no managed cluster, and the DigitalOcean API listed no clusters. Red created cluster `be709b80-df9d-4bf0-8d6b-5333c650d9a6` named `doks-dev`, the registry and its integration. Red check passed with worker `doks-dev-3f1o90` Ready at `159.223.1.98`.

Blue create then converged the same cluster and registry. Blue check passed with the same cluster ID and Ready worker. Blue kubeconfig refreshed the generated credential. Red registry obtained an owner-only, one-hour push credential without printing its contents.

The installed standalone Red and Blue launchers passed build and create dry-run. Each root launcher matches its installed skill payload. The launchers pin DOKS implementation `8120674e81d88827c4e8b6eaa899b0c5fbaf829c`.

The accompanying SDK logs cover both native controllers against the actual Kubernetes API. Their package adapters simulated infrastructure in memory. They do not prove Redis provisioning. The test namespace and CRD were removed after the checks.

The cluster and registry remain available to `redis-operator-doks`. No cluster deletion was attempted.
