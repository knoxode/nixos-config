# Agent Instructions — alexos

## Purpose
Maintain and simplify this multi-host NixOS flake. Prioritize correctness, readability, declarative configuration, maintainability. Prefer removing config over adding abstractions.

## Repository Context
- **System:** NixOS flakes + Home Manager
- **Desktop:** Hyprland (Wayland)
- **Editor:** Neovim via nvf/mnw
- **Shell:** Zsh
- **Hosts:** reuby, node, nomad (different effective settings)
- **Root:** `flake.nix`, `flake.lock`

Use NixOS modules (system), Home Manager (user), `hosts/`/`profiles/` (host-specific).

## Working Principles
- Smallest change that satisfies the request
- Prefer native/upstream options over custom ones
- Prefer upstream defaults over reproducing them
- Preserve intentional customizations
- Follow existing conventions; avoid unnecessary helpers/abstractions
- No unrelated file modifications
- Never modify `flake.lock`, update inputs, or commit unless explicitly requested

## Investigation
- Inspect relevant files/imports before editing
- Targeted searches > broad exploration
- Check effective option values when merging/conditionals matter
- Prefer pinned sources and local module definitions
- Consult upstream docs when necessary, not speculatively
- Stop once sufficient evidence exists

## Validation
**Use the cheapest meaningful validation:**

| Change Type | Validation |
|-------------|------------|
| Formatting | Check formatting only |
| Application settings | Evaluate affected option / HM config |
| Module changes | Evaluate affected host config |
| Shared modules | Validate representative affected hosts |
| System integration | Build only when eval insufficient |

**Targeted eval (context-dependent — not always needed):**
```sh
nix eval '.#nixosConfigurations.<host>.config.<option>'
nix eval '.#nixosConfigurations.<host>.config.home-manager.users.<user>.<option>'
```
Use actual host/user names. Add `--json` for structured values.

**Constraints:**
- Targeted `nix eval` > broad checks/builds (but skip for pure Lua/config changes that don't affect Nix eval, e.g. Hyprland Lua binds)
- No activation commands (`nixos-rebuild switch`, etc.) unless requested
- No interactive apps or dependency updates
- Timeouts for blocking commands; investigate failures before retry
- Don't repeat successful checks unless invalidated
- Successful eval ≠ successful build/runtime

## Git Workflow
1. **Branch & commit** changes on a feature branch
2. **Push** to origin
3. **Open PR** (auto-merge armed via GraphQL)
4. **Let gates decide** — required checks: 3 evals + Build gate

```sh
# Push branch
git push -u origin <branch>

# Open PR + arm auto-merge
TOKEN=$(cat /run/secrets/github/token)
PRID=$(curl -s -H "Authorization: Bearer $TOKEN" \
  https://api.github.com/repos/knoxode/nixos-config/pulls/<n> | jq -r '.node_id')
curl -s -H "Authorization: Bearer $TOKEN" -X POST https://api.github.com/graphql \
  -d "{\"query\":\"mutation(\$id: ID!){enablePullRequestAutoMerge(input:{pullRequestId:\$id,mergeMethod:SQUASH}){pullRequest{number}}}\",\"variables\":{\"id\":\"$PRID\"}}"
```

**Merge notes:**
- Sync merge: **PUT** `/pulls/<n>/merge` (only when checks green)
- Skipped checks (config PRs) = satisfied; cancelled/failed ≠ satisfied
- Token: fine-grained PAT (Contents RW + PRs RW, no admin), at `/run/secrets/github/token` (0400). Read per-call, never export/print/commit. Rotate on 401 via `sops secrets/secrets.yaml` + rebuild.

## Completion
- Stop once change is implemented and validated
- No scope expansion or speculative cleanup
- If blocked/uncertain → report, don't guess
- Report changes, modified files, validation results, unresolved issues concisely

## Documentation Reference
See `docs/` for details:

| Area | Document |
|------|----------|
| Keybindings (all layers) | `docs/keybindings/README.md` |
| Cross-layer conflicts | `docs/keybindings/conflicts.md` |
| Hyprland architecture | `docs/architecture/hyprland.md` |
| Troubleshooting builds | `docs/operations/troubleshooting.md` |
| Secrets management | `docs/operations/secrets.md` |
| Monitor hotplug | `docs/operations/monitor-hotplug.md` |
| CI / GitHub Actions | `docs/operations/ci.md` |
| Ghostty config dump | `docs/reference/ghostty-config.md` |
| Noctalia config dump | `docs/reference/noctalia-config.md` |
| nvf modules enabled | `docs/reference/nvf-modules.md` |

### When Modifying Keybindings
1. Check `docs/keybindings/conflicts.md` for existing conflicts
2. Verify current bindings in each config file
3. Test at runtime: `ghostty +list-keybinds`, `hyprctl binds`, `:map` in Neovim
4. Check upstream docs (don't rely on existing config):
   - Hyprland: <https://wiki.hypr.land> + <https://alejandrominaya.github.io/hyprland-lua-docs/>
   - Ghostty: <https://ghostty.org/docs/config/reference>
   - nvf: <https://nvf.notashelf.dev/options.html>
   - nixpkgs: <https://search.nixos.org/options>
5. Update `docs/keybindings/conflicts.md` if conflicts change