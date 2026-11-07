# CI / GitHub Actions

**Source**: `README.md` + `.github/workflows/check.yml` + `.github/workflows/update-flake.yml`

---

## Workflow: `CI — Evaluate & Build Hosts` (`.github/workflows/check.yml`)

Runs on every PR and push.

### Jobs

| Job | Runs On | Proves |
|-----|---------|--------|
| `Evaluate <host>` ×3 | Every PR and push | Config evaluates for reuby, node, nomad |
| `Build <host>` ×3 | `flake.lock`-changing PRs (daily lock update) + manual dispatch | Full system closures build |
| `Build gate` | Always (aggregate) | Stable required check: green on build success/skip, red on failure |

Build triggers are decided by a paths-filter on `flake.lock` (not labels):
config-only PRs skip builds and get a green gate.

### Binary Cache (alexos.cachix.org)

- **Consumption**: build jobs install `alexos.cachix.org` as a substituter
  (cachix-action, pull-only) before building. They also add the hosts'
  upstream substituters via the nix-installer `extra-conf`: `hyprland`,
  `winapps`, `noctalia`, and `cache.lantian.pub` (xddxdd's CachyOS kernel
  cache). The CachyOS kernel is not in `cache.nixos.org` or in a fresh
  `alexos` cache, so omitting `lantian` rebuilds it from source on every
  host (~2 h each).
- **Publishing**: every build step publishes to the cache regardless of the
  build outcome (`nix path-info --all | cachix push`). Cachix skips paths
  already present, so the full closure uploads with green and only the
  surviving constituents when red. Retries and local machines then pull
  the already-built parts instead of rebuilding.
- **Safety**: the cache does not gate anything. The `Build gate` required
  check keeps failed builds out of `main`; content addressing keeps pulls
  correct. Pushing partial closures on a red build is therefore safe.

### Build Logging

Builds use `nix build --log-format raw-with-logs` and tee the human-readable
output to `build.log`. This is far smaller than the old `internal-json`
stream (~1 GB per job), so the Actions log stays readable while the job runs.
The failure-analysis step streams `build.log`, extracts failed derivation
paths from Nix's `error:` lines, and appends `nix log` tails to the PR
comment.

### Nix Store Caching (GitHub Actions cache)

`nix-community/cache-nix-action` snapshots the runner store in eval and
build jobs, keyed on `hashFiles('flake.lock')`. Restore uses host-specific
`restore-prefixes-all-matches` so a fresh lock PR can see caches from `main`
and earlier runs; `restore-prefixes-first-match` only searches the current
ref and therefore always misses on a new PR. Each build entry is capped at
`3G` so three host caches fit inside the repo-wide 10 GB limit; anything
beyond the cap is covered by cachix.

GHA store caches are best-effort (the 10 GB repo cap evicts old entries).
The cachix and upstream binary caches are the authoritative closure cache;
the GHA cache mainly avoids re-fetching flake inputs and recently built
stores.

### Required Status Checks

- Three evals (`Evaluate reuby`, `Evaluate node`, `Evaluate nomad`)
- `Build gate` (aggregate)

**Merges**: Squash-merges via auto-merge once required checks pass. Broken locks cannot reach `main` unverified.

- Config PRs merge in ~2 min (builds skip)
- Lock PRs wait for full builds (minutes when upstream caches are warm;
  longer when a kernel or other input must build)

---

## Lock Update Automation

`Maintenance — Auto-update flake.lock` (`update-flake.yml`) opens a lock PR
daily and arms auto-merge on it. Reuses the same PR branch — a red lock PR
is not duplicated daily; it rebases and retries. It updates every input, not
just nixpkgs.

GitHub can start scheduled workflows several hours after the cron time, so
"daily" means once per day rather than exactly at 03:43 UTC. The Check
schedule is later in the file and runs after the updater in practice.

A lock update does not by itself invalidate the whole cache. The expensive
CachyOS kernel comes from a separate input; because CI now consumes
`cache.lantian.pub`, a kernel bump that upstream has cached substitutes
instead of rebuilding from source.

---

## nixpkgs Channel Strategy
 
### Current: Follow nixos-unstable branch HEAD
 
```nix
nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"
```
 
**Tradeoff:** Instant access to fixes/features vs. occasional broken rev.
 
**Mitigation:** Daily lock PR + build gate (3 hosts) blocks broken revs from `main`.
On red build, failure-analysis step posts PR comment with:
- Failed derivations + exit codes + log tails
- Upstream nixpkgs commit range (old-lock..new-lock) with GitHub compare link
- Ready-to-commit overlay snippet for affected host(s)
 
**Fix flow:** Maintainer commits overlay to lock PR branch → gate re-runs green → auto-merge.
When upstream fixes it, revert overlay → next daily update picks up fixed rev.
 
**Pin tracking:** `pin-tracker.yml` scans the last 30 days for
`pin: <pkg> — Revert when ...` commits on every push to `main` (plus weekly)
and opens one issue per pin. A later `unpin: <pkg> — ...` commit closes it.
 
---

## Branch Protection

- Required checks: 3 evals + Build gate
- Auto-merge enabled via `gh pr merge --auto --squash` (GraphQL under the hood)
- Fine-grained PAT for CI: repo-scoped, Contents RW + Pull requests RW, no admin
- Token stored via sops-nix as `github/token` → materialized at `/run/secrets/github/token` (mode 0400)

---

## Pull Requests

Manage PRs with `gh` (authenticated as `knoxode` via
`~/.config/gh/hosts.yml`):

```sh
gh pr create --fill
gh pr merge --auto --squash <n>   # arm auto-merge
gh pr merge --squash <n>          # synchronous merge, only when green
```

No manual token or curl/GraphQL calls are needed for interactive work. Use
the fine-grained PAT only where a workflow/script cannot use `gh`:

```sh
GH_TOKEN=$(cat /run/secrets/github/token) gh <command>
```

Read the token per call; never export, print, or commit it.

**Skipped required checks** (config PRs where `Build *` jobs skip) count as satisfied. Cancelled or failed checks do not.

---

## Local Validation

```bash
# Evaluate host config
nix eval '.#nixosConfigurations.reuby.config.<option>' --json

# Build host closure
nix build '.#nixosConfigurations.reuby.config.system.build.toplevel'

# Check flake
nix flake check
```