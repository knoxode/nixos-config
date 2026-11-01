# Secrets Management

**Source**: `README.md` + `modules/core/sops.nix`

---

## Overview

Secrets managed with **sops-nix** (`secrets/secrets.yaml`, age key at `~/.config/sops/age/keys.txt`). Declared in `modules/core/sops.nix`, materialized at `/run/secrets/<name>`.

---

## Structure

```
secrets/
├── secrets.yaml          # Encrypted secrets (sops format)
└── .sops.yaml            # sops config (age keys, creation rules)
```

---

## Key Files

| File | Purpose |
|------|---------|
| `secrets/secrets.yaml` | Encrypted secrets (Git-tracked) |
| `~/.config/sops/age/keys.txt` | Age private key (NOT in repo) |
| `modules/core/sops.nix` | sops-nix module configuration |

---

## Adding a Secret

```bash
# Edit secrets (opens in $EDITOR)
sops secrets/secrets.yaml

# Or add programmatically
sops --set '["github"]["token"]' "ghp_..." secrets/secrets.yaml
```

Secrets are encrypted with age keys defined in `.sops.yaml`.

---

## Accessing in Nix

```nix
{ config, ... }: {
  environment.variables.GITHUB_TOKEN = config.sops.secrets.github_token;
}
```

Or as file:
```nix
{ config, ... }: {
  systemd.services.my-service.environment.GITHUB_TOKEN_FILE = config.sops.secrets.github_token;
}
```

---

## Materialization

Secrets are materialized at `/run/secrets/<name>` (mode 0400).

**Never**:
- Export secrets to environment variables globally
- Print secrets in logs/output
- Commit plaintext secrets

**Always**:
- Read per-call: `TOKEN=$(cat /run/secrets/github/token)`
- Use `sops.secrets.<name>` in Nix config
- Rotate via `sops secrets/secrets.yaml` + rebuild if compromised (401 from GitHub API)

---

## GitHub Token (Example)

Used for auto-merge PR workflow:

```bash
# Read per-call
TOKEN=$(cat /run/secrets/github/token)
curl -H "Authorization: Bearer $TOKEN" ...
```

**Token scope**: Fine-grained PAT (repo: Contents RW + Pull requests RW, no admin). Expires — rotate via `sops secrets/secrets.yaml` + rebuild.

---

## Rotation

1. Generate new secret (GitHub PAT, API key, etc.)
2. `sops secrets/secrets.yaml` → update value
3. Commit + push
4. Rebuild affected hosts: `nixos-rebuild switch` / `home-manager switch`
5. Verify new secret works
6. Revoke old secret