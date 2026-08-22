# Repository Guidelines

## Development Environment

This repository uses a Nix flake. Run commands that require project tooling through `nix develop`. Prefer `nix shell` for tools that are only needed once.

## SSH Target

The target NixOS host is available as `jinji@ssh.floating-gate.com`:

```sh
ssh jinji@ssh.floating-gate.com
```

Use SSH only when an operation must run on the target machine, such as inspecting its runtime state or applying a configuration.

## Editing Configuration

For changes to the NixOS configuration or other repository files, edit the files in this directory directly. Do not SSH into the target machine merely to modify configuration files; this repository is the source of truth for those changes.
