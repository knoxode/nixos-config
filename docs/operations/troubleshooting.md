# Troubleshooting

**Source**: `README.md` — "When something breaks" section

---

## Red Lock PR (Build Failure)

A red lock PR means one of the moved inputs broke the closure build.

**`nixpkgs` is almost never the culprit** — channel revs are pre-verified by Hydra. Suspect whichever **other inputs** moved in the diff.

### Unblock: Pin Broken Input

Pin the offending input to its last-known-good rev in `flake.nix`:

```nix
firefox.url = "github:nix-community/flake-firefox-nightly/7a44b6c";  # temporarily
```

Then `nix flake lock` and push to the lock PR branch. The gate verifies the pinned state still builds and remaining updates merge. Remove the pin once upstream lands a fixed rev — the next daily update will pick it up.

This is the same pattern as the long-standing `nixpkgs-snapgene` pin.

---

## One-Machine Emergency (Fix on HEAD, Channel Behind)

Rebuild locally with an override — touch nothing in the repo:

```sh
nixos-rebuild switch --flake .#reuby \
  --override-input nixpkgs github:NixOS/nixpkgs/nixos-unstable
```

---

## All Hosts Need HEAD Now

Temporarily point `nixpkgs.url` at branch HEAD in a PR:

```nix
nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
```

The build gate verifies HEAD before it can merge. Revert once the channel catches up.

---

## Channel Monitoring

| URL | Purpose |
|-----|---------|
| <https://channels.nixos.org/nixos-unstable> | Published revision + "last updated" |
| <https://channels.nixos.org/nixos-unstable/git-revision> | Same as plain text (for scripts) |
| <https://hydra.nixos.org/jobset/nixpkgs/unstable> | Jobset feeding the channel. "Last checked: with errors" = latest HEAD still failing |
| <https://nixpk.gs/pr-tracker.html?branch=nixos-unstable> | Track nixpkgs PR through merge → channel → release |

**Lock PR diff is self-reporting**: If it contains no `nixpkgs` lines, the channel has not advanced since last update.

---

## Common Issues

| Symptom | Likely Cause | Fix |
|---------|--------------|-----|
| Lock PR fails to build | Non-nixpkgs input moved to broken rev | Pin input to last-good rev |
| Config evaluates but doesn't build | Runtime dependency missing | Check `buildInputs` / `nativeBuildInputs` |
| Hyprland reload breaks | Lua error in event handler | Check `~/.local/state/hypr/alexos.log` |
| Home Manager switch fails | Option value changed type | Check option docs at <https://search.nixos.org/options> |

---

## Quick Commands

```bash
# Evaluate single host
nix eval '.#nixosConfigurations.reuby.config.<option>'

# Build without switching
nix build '.#nixosConfigurations.reuby.config.system.build.toplevel'

# Check flake inputs
nix flake metadata

# Show lock diff
nix flake lock --dry-run
```