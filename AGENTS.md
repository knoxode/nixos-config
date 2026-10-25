# Agent Instructions — alexos

## Purpose

Maintain and simplify this multi-host NixOS flake.

Prioritize correctness, readability, declarative configuration, and
maintainability. Prefer removing unnecessary configuration over introducing
abstractions.

## Repository Context

- **System:** NixOS flakes with Home Manager.
- **Desktop:** Hyprland on Wayland.
- **Editor:** Neovim configured through nvf and mnw.
- **Shell:** Zsh.
- **Hosts:** Multiple configurations with potentially different effective
  settings.
- **Root:** `flake.nix` and `flake.lock`.

Use NixOS modules for system configuration, Home Manager for user settings, and
`hosts/` or `profiles/` for host-specific configuration where appropriate.

## Working Principles

- Make the smallest change that satisfies the request.
- Prefer native NixOS, Home Manager, and upstream module options.
- Prefer upstream defaults over explicitly reproducing them.
- Preserve intentional customizations and existing behaviour unless instructed
  otherwise.
- Follow existing conventions; avoid unnecessary helpers, modules, and
  abstractions.
- Do not modify unrelated files or overwrite unrelated user changes.
- Never modify `flake.lock`, update inputs, or commit unless explicitly
  requested.

## Investigation

- Inspect relevant files and imports before editing.
- Prefer targeted searches over broad repository exploration.
- Check effective option values when module merging or conditional definitions
  matter.
- Prefer pinned sources and local module definitions when determining option
  behaviour.
- Consult upstream documentation when necessary, not speculatively.
- Stop investigating once sufficient evidence exists to implement the change.

## Validation

Use the cheapest meaningful validation for the change.

- **Formatting:** Check formatting only.
- **Application settings:** Evaluate the affected option or Home Manager
  configuration.
- **Module changes:** Evaluate the affected host configuration.
- **Shared modules:** Validate representative affected hosts.
- **System integration:** Build only when evaluation is insufficient.

Prefer targeted evaluation of effective options:

```sh
nix eval '.#nixosConfigurations.<host>.config.<option>'
nix eval '.#nixosConfigurations.<host>.config.home-manager.users.<user>.<option>'
```

Use actual host and user names. Add `--json` for structured values.

Additional constraints:

- Prefer targeted `nix eval` over broad checks or builds.
- Do not run activation commands (`nixos-rebuild switch`, `home-manager switch`,
  etc.) unless explicitly requested.
- Do not launch interactive applications or update dependencies.
- Use timeouts for potentially blocking commands; investigate failures before
  retrying.
- Do not repeat successful checks unless subsequent changes invalidate them.
- Do not confuse successful evaluation with successful builds or runtime
  verification.

## Completion

- Stop once the requested change is implemented and appropriately validated.
- Do not expand scope or perform speculative cleanup.
- If blocked or uncertain, report the issue rather than guessing.
- Report changes, modified files, validation results, and unresolved issues
  concisely.
