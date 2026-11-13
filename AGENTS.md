# Agent instruction for anmoti/dotfiles

This file provides guidance when working with this repository.
Keep this file (and README.md) up to date as the configuration evolves.

## Overview

Personal dotfiles managed by chezmoi.
Package management uses Nix + Home Manager (standalone, not NixOS).
Primary target is x86_64-linux; chezmoi templates handle platform differences (Linux/Windows).

Many tools configured here (Hyprland, AI integrations, etc.) are rapidly evolving.
Always verify against the latest upstream documentation before making changes.

## Why chezmoi + Home Manager

- **chezmoi**: Used because the dotfiles also need to work on Windows.
  Any config file for software that also runs on Windows must be managed by chezmoi, not Home Manager.
- **Home Manager**: Used to avoid the burden of manually installing binary dependencies across machines.
  Home Manager manages **binaries only** (LSP servers, CLI tools, etc.).
  Config files stay in chezmoi; application-level plugins (e.g., Neovim plugins) are managed by the application's own plugin manager (lazy.nvim).

## Key Commands

```bash
# Apply dotfile changes to home directory
chezmoi apply

# Sync a file from home directory back into the chezmoi source
chezmoi re-add <file>

# Apply Home Manager config changes (default flake path: ~/.config/home-manager)
home-manager switch

# Update flake inputs and optionally sync flake.lock back into chezmoi
hm update

# Update skill sources (npins) and optionally sync npins/sources.json back into chezmoi
hm skills

# List installed packages with versions and sizes
hm list
```

## Deleting Files

chezmoi does **not** delete files from the home directory when they are removed from the source repository.
When a file is removed from chezmoi source, always ask the user to manually delete the corresponding file from their home directory.

## Workspaces (jj)

Experimental changes are kept out of `main` by developing each feature in its own jj workspace.
The repository root (`~/.local/share/chezmoi`, where `.git` and `.jj` live) is also chezmoi's source dir
and checks out `main`; it is the state that `chezmoi apply` writes.

```
~/.local/share/chezmoi                          repo root + workspace main  (chezmoi sourceDir; applied by `chezmoi apply`)
~/wip/git/github.com/anmoti/dotfiles-feat-<x>   workspace feat/<x>         (one workspace per change; uncommitted is fine)
```

- `~/.config/chezmoi/chezmoi.toml` is machine-local and **not** managed by this repo.
  `sourceDir` stays at the default; only the update command is overridden:

```toml
# `chezmoi update` fetches and moves the working copy onto `main` instead of `git pull`
[update]
command = "sh"
args = ["-c", "jj git fetch && jj new main"]
```

- `chezmoi apply` applies exactly what is checked out at the repository root.
  There is no overlay merge, hook, or change routing: the workspace you edit is the one that gets applied.
- To try a feature workspace on its own, apply it with `--source`:

  ```sh
  chezmoi --source ~/wip/git/github.com/anmoti/dotfiles-feat-<x> apply
  ```

- `chezmoi add` / `re-add` write into the repository root; commit them there.
- Create a workspace with:

  ```sh
  cd ~/.local/share/chezmoi
  jj workspace add --colocate --name feat/<x> ~/wip/git/github.com/anmoti/dotfiles-feat-<x> -r main
  ```

- `chezmoi update` does the fetch and the follow-up itself; if you run `jj git fetch` by hand,
  run `jj new main` (or a rebase) afterwards so the applied working copy catches up.
  The working copy does not follow the bookmark by itself.
- `jj` does not follow renames when merging (git's merge does). Rebase a workspace onto `main` when `main` renames files.

Rules for agents:

- Workspaces keep parallel pieces of work from getting mixed up: one workspace per change (`feat/*`, `chore/*`, …).
  Make changes in such a workspace (create one if none fits).
  The repository root is the user's own `main` checkout: they touch it by hand (e.g. `hm update`) and commit what goes upstream.
  Do not edit there unless the user explicitly says so.
  If it is unclear which workspace a change belongs to, ask before editing.
  Uncommitted changes in other workspaces are intentional; do not commit them.
- `~/.local/share/chezmoi` is only a store: never edit files there, and never point `chezmoi` at it.

## chezmoi File Naming Conventions

- `dot_` prefix → `.` in home directory (e.g., `dot_config/` → `~/.config/`)
- `executable_` prefix → file is chmod +x on apply
- `private_` prefix → file is chmod 600 on apply
- `.tmpl` suffix → Go template processed by chezmoi (has access to variables like `.chezmoi.homeDir`, `.chezmoi.os`)
- `run_onchange_after_*.sh.tmpl` → script runs when its content hash changes

## Architecture

### chezmoi Source Layout

```
.chezmoiscripts/       # Scripts run on chezmoi apply
dot_config/
  home-manager/        # Nix Home Manager flake
  nix/                 # nix.conf (binary caches)
  nvim/                # Neovim config
  hypr/                # Hyprland WM config (Lua)
  sway/                # Sway WM config
  waybar/              # Status bar
  kitty/, alacritty/   # Terminals
  fuzzel/              # App launcher
  nwg-drawer/          # App drawer
  oh-my-posh/          # Shell prompt theme
  satty/               # Screenshot annotation
  udev/                # udev rules (must be manually copied to /etc/udev/rules.d/ as root)
dot_local/bin/         # Custom scripts placed in PATH (hm, term, …)
dot_gitconfig.tmpl     # Git config (template for 1Password SSH signing)
dot_wakatime.cfg.tmpl  # WakaTime config (template)
dot_editorconfig       # EditorConfig
```

### Home Manager Flake (`dot_config/home-manager/`)

Two configurations: `anmoti` (base) and `anmoti@LEGION5` (desktop, adds GUI/Wayland packages).
Composed from `modules/` (base, zsh, neovim, fonts) and `profiles/`.

**Default channel: always use `pkgs` (`nixos-26.05`) unless the user explicitly requests unstable.**
Use `pkgu` only when a package is unavailable in `pkgs` or the user specifically asks for the unstable version.

Packages from two nixpkgs channels — `pkgs` (`nixos-26.05`) and `pkgu` (unstable) — plus
`llm-agents.nix` (github:numtide/llm-agents.nix) for AI binaries (`claude-code`, `copilot-language-server`).
`cache.numtide.com` is configured as a binary substituter in `dot_config/nix/nix.conf` (not in the flake's `nixConfig`, so it also applies to `nix shell` etc.); without it these packages build from source.
Custom packages live in `pkgs/`.

Both home configurations pass `packages = localPackages` via `extraSpecialArgs`, so all modules receive a `packages` argument.
Binaries from `llm-agents.nix` and custom `pkgs/` must be referenced as `packages.claude-code` etc. — they do not exist in `pkgs` or `pkgu`.

Neovim (`modules/neovim.nix`) uses `extraWrapperArgs` to set a sandboxed `$PATH` containing only explicitly declared binaries (LSPs, formatters, etc.).
The original `$PATH` is preserved as `$HOST_PATH`.
**Any LSP or CLI tool that Neovim needs must be declared in `modules/neovim.nix`** — system-installed binaries are not visible inside Neovim.

### Neovim Config (`dot_config/nvim/`)

Plugin manager: lazy.nvim.
Plugins are organized under `lua/plugins/` by category (`theme/`, `ui/`, `util/`, `lang/`, `ai/`);
each category has both a flat loader file (e.g., `lang.lua`) and a subdirectory for per-plugin files (e.g., `lang/`).
Prefer adding new plugins as individual files under the subdirectory (e.g., `lang/foo.lua`) rather than appending to the flat loader file.
`common.lua` is reserved for plugins used only as dependencies by other plugins — not for standalone plugins.
Core settings live in `lua/configs/`.

Nix-installed rtp packages (treesitter parsers, etc.) are preserved via `performance.rtp.paths`,
which globs all `pack/*/start/*` entries from `packpath` — because lazy.nvim resets the rtp by default.

### Hyprland Config (`dot_config/hypr/`)

Config files are written in Lua (Hyprland's native Lua config support).
`local.lua` is gitignored for machine-specific overrides.

### Automatic Home Manager Switch

`run_onchange_after_nix-switch.sh.tmpl` triggers `home-manager switch` automatically when `chezmoi apply` detects changes.
The mechanism: chezmoi re-runs a `run_onchange_*` script only when the script's own content changes,
so the template embeds a hash of all files under `dot_config/home-manager/` via `{{ output "sh" "-c" "find ... | sha256sum" }}` —
making the script re-run whenever any Home Manager config or `flake.lock` changes.
