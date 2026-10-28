# alexos

Multi-host NixOS flake (reuby, node, nomad) with Home Manager, Hyprland on
Wayland, and Neovim via nvf/mnw.

See `AGENTS.md` for maintenance conventions.

## CI — what verifies what

Every PR runs a `Check` workflow (`.github/workflows/check.yml`):

| Job | Runs on | Proves |
|---|---|---|
| `Evaluate <host>` ×3 | every PR and push | the config evaluates |
| `Build <host>` ×3 | `flake-lock`-labeled PRs (the daily lock update) and manual dispatch | the full system closures build |
| `Build gate` | always (aggregate over the build matrix) | stable required check: green on build success or skip, red on failure |

Required status checks: the three evals plus `Build gate`. Merges are
squash-merges and happen via auto-merge once required checks pass — broken
locks cannot reach `main` unverified. Config PRs merge in ~2 minutes
(builds skip for them); lock PRs wait for full builds (~hours).

`update-flake.yml` opens a lock PR daily and arms auto-merge on it. It
reuses the same PR branch, so a red lock PR is not duplicated daily — it
rebases and retries.

## nixpkgs follows the channel, not the branch

`flake.nix` pins nixpkgs to
<https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz> — a channel
tarball URL that only ever resolves to a **published channel revision**:
one Hydra has fully built *and* passed its test suite. Lock updates can
therefore never adopt a nixpkgs rev that is missing from
<https://cache.nixos.org>, which is what historically made lock PRs fail
on fetch/build errors (see PR #16).

The cost: we are a few days behind branch HEAD. The fix for that is
usually waiting; see "When HEAD has the fix" below.

### Watching the channel in a browser

- <https://channels.nixos.org/nixos-unstable> — what is published right
  now (revision + "last updated").
- <https://channels.nixos.org/nixos-unstable/git-revision> — the same, as
  plain text (this is what scripts curl).
- <https://hydra.nixos.org/jobset/nixpkgs/unstable> — the jobset feeding
  the channel. Each row is a branch HEAD being built; the channel advances
  when the `tested` job succeeds. "Last checked: with errors" means the
  latest HEAD is still failing somewhere — a good reason the channel has
  not advanced.
- <https://nixpk.gs/pr-tracker.html?branch=nixos-unstable> — track an
  nixpkgs PR through merge → channel → release.

The lock PR diff is self-reporting: if it contains no `nixpkgs` lines,
the channel has not advanced since our last update.

## When something breaks

A red lock PR means one of the moved inputs broke the closure build.
`nixpkgs` is almost never the culprit (channel revs are pre-verified) —
suspect whichever other inputs moved in the diff.

To unblock everything while upstream fixes itself, pin the broken input
to its last-known-good rev in `flake.nix`:

```nix
firefox.url = "github:nix-community/flake-firefox-nightly/7a44b6c";  # temporarily
```

(this is the same pattern as the long-standing `nixpkgs-snapgene` pin),
`nix flake lock`, and push to the lock PR branch. The gate then verifies
the pinned state still builds and the remaining updates merge. Remove the
pin once upstream lands a fixed rev — the next daily update will pick it
up.

For a one-machine emergency (fix exists on branch HEAD, channel has not
caught up), rebuild locally with an override and touch nothing:

```sh
nixos-rebuild switch --flake .#reuby \
  --override-input nixpkgs github:NixOS/nixpkgs/nixos-unstable
```

If all hosts genuinely need HEAD now, temporarily point `nixpkgs.url` at
`github:NixOS/nixpkgs/nixos-unstable` in a PR — the build gate then
verifies HEAD before it can merge — and revert once the channel catches
up.

## Secrets

Managed with sops-nix (`secrets/secrets.yaml`, age key at
`~/.config/sops/age/keys.txt`). Declared in `modules/core/sops.nix`,
materialized at `/run/secrets/<name>`.
