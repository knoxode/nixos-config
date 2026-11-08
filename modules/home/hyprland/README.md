# Hyprland Lua configuration

The architecture, execution model, diagnostics, machine policy, and API notes
live in [`docs/architecture/hyprland.md`](../../../docs/architecture/hyprland.md).

The Lua modules themselves are in this directory; `default.nix` deploys them
into `~/.config/hypr/`. Host data is generated from
`hosts/<host>/default.nix` (`alexos.host.hyprland`).
