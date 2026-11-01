# CI / GitHub Actions

**Source**: `README.md` + `.github/workflows/check.yml`

---

## Workflow: `Check` (`.github/workflows/check.yml`)

Runs on every PR and push.

### Jobs

| Job | Runs On | Proves |
|-----|---------|--------|
| `Evaluate <host>` ×3 | Every PR and push | Config evaluates for reuby, node, nomad |
| `Build <host>` ×3 | `flake-lock`-labeled PRs (daily lock update) + manual dispatch | Full system closures build |
| `Build gate` | Always (aggregate) | Stable required check: green on build success/skip, red on failure |

### Required Status Checks

- Three evals (`Evaluate reuby`, `Evaluate node`, `Evaluate nomad`)
- `Build gate` (aggregate)

**Merges**: Squash-merges via auto-merge once required checks pass. Broken locks cannot reach `main` unverified.

- Config PRs merge in ~2 min (builds skip)
- Lock PRs wait for full builds (~hours)

---

## Lock Update Automation

`update-flake.yml` opens a lock PR daily and arms auto-merge on it. Reuses the same PR branch — a red lock PR is not duplicated daily; it rebases and retries.

---

## nixpkgs Channel Strategy

`flake.nix` pins nixpkgs to:
```
https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz
```

- Channel tarball URL → only resolves to **published channel revision** (Hydra built + passed tests)
- Lock updates can never adopt a nixpkgs rev missing from <https://cache.nixos.org>
- Cost: a few days behind branch HEAD
- Fix: usually waiting; see "When HEAD has the fix" in troubleshooting.md

---

## Branch Protection

- Required checks: 3 evals + Build gate
- Auto-merge enabled via GraphQL (REST endpoint returns 404 for fine-grained PATs)
- Fine-grained PAT: repo-scoped, Contents RW + Pull requests RW, no admin
- Token stored via sops-nix as `github/token` → materialized at `/run/secrets/github/token` (mode 0400)

---

## Merge Endpoints

| Action | Endpoint | Method |
|--------|----------|--------|
| Auto-merge | `/graphql` | POST (mutation `enablePullRequestAutoMerge`) |
| Sync merge (green checks) | `/pulls/<n>/merge` | **PUT** (POST returns 404) |

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