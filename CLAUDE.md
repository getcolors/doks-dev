# CLAUDE.md

Guidance for agents working in this deployment. Read
`~/code/getcolors/CLAUDE.md` first.

## What this is

Desired state only. No source code. `colors.yml` is the single file to edit;
everything else is generated (`.colors/`), secret (`.envrc.private`), or an
installed copy of the [`doks`](https://github.com/getcolors/doks) Package Skill
launcher.

## Things specific to this deployment

- **A platform for another deployment.** `redis-operator-doks` exports
  `KUBECONFIG` pointing at this repository's `.colors/doks-dev/kubeconfig` and
  pulls its controller image from the registry this deployment owns. Delete
  that deployment before this one.
- **The registry is deployment-owned.** `digitalocean-registry-tier: basic`
  creates registry `doks-dev`; DOKS registry integration injects the pull
  Secret named `doks-dev` into every namespace of the cluster.
- **Worker public IPs change on replacement.** `./green check` prints them;
  the Redis operator's `digitalocean-ssh-sources` must list the current one.

## The launcher is a copy

`./green` is a copy of `.agents/skills/package-doks-green/green`. After
`npx skills update -p`, copy it again and compare; `skills-lock.json` records
the installed pin.

## Safety

- Never edit `.colors/`, never commit it, never read it as source.
- Keep `compute-prevent-destroy: true`; lift it only for one authorized
  `delete` through `COLORS_PAR_COMPUTE_PREVENT_DESTROY=false`.
- Never export `COLORS_PAR_PROFILE`.
- Run `./green build` and `./green create --dry-run` before any live change.
