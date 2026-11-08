# alexos

Multi-host NixOS flake (reuby, node, nomad) with Home Manager, Hyprland on
Wayland, and Neovim via nvf/mnw.

See `AGENTS.md` for maintenance conventions.

## CI

Every PR runs the `CI — Evaluate & Build Hosts` workflow
(`.github/workflows/check.yml`). Required gates are `Evaluate gate` for
config changes and merges, and `Build gate` when `flake.lock` changes.
Builds publish to `alexos.cachix.org`, and `update-flake.yml` opens a lock
PR daily. See `docs/operations/ci.md` for the job table, cache, failure
handling, and channel strategy.

## nixpkgs follows nixos-unstable HEAD

`flake.nix` points nixpkgs at `github:NixOS/nixpkgs/nixos-unstable`, so a
lock update can adopt a revision before Hydra has published it to
<https://cache.nixos.org>. The daily build gate (three hosts) is what stops
a broken rev from merging. CI also consumes the hosts' upstream
substituters, including xddxdd's CachyOS kernel cache, so a lock bump
substitutes expensive inputs instead of rebuilding them from source.

The tradeoff: instant access to fixes and features versus an occasional
cache miss. If HEAD outruns the cache, wait for Hydra or pin the offending
input; see "When something breaks" below.

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

The lock PR diff is self-reporting: if it contains no `nixpkgs` lines, the
nixpkgs input did not move that day.

## When something breaks

A red lock PR means one of the moved inputs broke the closure build.
Because nixpkgs follows HEAD, the new nixpkgs rev is a candidate; so is any
other input that moved in the diff. The failure comment lists the failed
derivations and the nixpkgs compare range.

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

For a one-machine emergency where the daily lock has not picked up a fix
yet, rebuild locally with a fresh nixpkgs input and touch nothing:

```sh
nixos-rebuild switch --flake .#reuby \
  --override-input nixpkgs github:NixOS/nixpkgs/nixos-unstable
```

To get the same rev through the gate, run `nix flake update nixpkgs`, open
a PR, and let the build gate verify it.

## Secrets

Managed with sops-nix (`secrets/secrets.yaml`, age key at
`~/.config/sops/age/keys.txt`). Declared in `modules/core/sops.nix`,
materialized at `/run/secrets/<name>`.
