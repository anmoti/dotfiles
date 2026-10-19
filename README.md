# dotfiles

My dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

## Environment

- **WM**: Hyprland
- **Terminal**: Kitty (Alacritty also supported)
- **Editor**: Neovim
- **Shell**: Zsh (via Home Manager)
- **Bar**: Waybar
- **Launcher**: Fuzzel
- **Notifications**: Dunst
- **Input method**: Fcitx5 (Mozc-UT / SKK)

## Required Packages

### Hyprland

```
hyprland
xdg-desktop-portal-hyprland
hyprlock
hyprpicker
```

### Bar / Notifications

```
waybar
dunst
nm-applet
```

### Terminal

```
kitty
alacritty   # サブ端末として利用
```

### Input Method

```
fcitx5-im
fcitx5-mozc-ut
fcitx5-skk
```

### Apps

```
1password
nemo
fuzzel
nwg-drawer
vivaldi
```

### Screenshot / Color Picker

```
grim
slurp
satty
```

### Brightness / Monitor

```
ddcutil
brightnessctl
```

### Neovim

```
neovim
```

### Shell

```
oh-my-posh
```

## Setup

### Home Manager (Nix)

パッケージ管理には Home Manager を使用。

```bash
# フレーク更新 + chezmoi への反映
hm update

# インストール済みパッケージ一覧
hm list
```

### chezmoi

```bash
chezmoi init https://github.com/anmoti/dotfiles.git
chezmoi apply
```

### 実験的な変更の分離 (worktree)

機能ごとに git worktree を分け、`chezmoi apply` の前に `local-applied` ブランチへ合成する。
`~/.local/share/chezmoi` は `local-applied` をチェックアウトした適用専用の場所なので、直接編集・コミットしない。

| 場所 | ブランチ | 用途 |
|---|---|---|
| `~/.local/share/chezmoi` | `local-applied` | chezmoi の適用元 (自動で作り直す) |
| `~/wip/git/github.com/anmoti/dotfiles` | `main` | クリーンな作業領域 (`hm update` の変更もここ) |
| `~/wip/git/github.com/anmoti/dotfiles-feat-<名前>` | `feat/<名前>` | 機能ごとの実験領域 (未コミットでよい) |

```bash
# 新しい機能を始める
git -C ~/wip/git/github.com/anmoti/dotfiles worktree add -b feat/<名前> ~/wip/git/github.com/anmoti/dotfiles-feat-<名前> main

# feat/ 以外 (chore/ など) も合成される。外したいときはブランチ名を wip/<名前> にする
```

`chezmoi add` / `re-add` の後は、fzf で差分を移す worktree を選ぶ (Esc で中断)。
hook は `~/.config/chezmoi/chezmoi.toml` に書く。このファイルはマシン固有で、リポジトリでは管理しない。

```toml
[hooks.apply.pre]
script = "/home/anmoti/.local/bin/chezmoi-sync-worktrees"

[hooks.add.post]
script = "/home/anmoti/.local/bin/chezmoi-route-changes"

[hooks.re-add.post]
script = "/home/anmoti/.local/bin/chezmoi-route-changes"
```

競合した場合、`chezmoi apply` はエラーで止まる。該当する worktree の編集位置をずらして解消する。

## System Configuration

### ddcutil (外部モニター輝度制御)

```bash
echo 'SUBSYSTEM=="i2c-dev", KERNEL=="i2c-[0-9]*", GROUP="i2c"' | sudo tee /etc/udev/rules.d/45-myi2c.rules
sudo groupadd --system i2c
sudo usermod -aG i2c $USER
```

参考: https://www.ddcutil.com/i2c_permissions_using_group_i2c/

### udev (Razer BlackWidow Elite 音量ダイヤル無効化)

```bash
sudo mkdir -p /etc/udev/rules.d/
sudo ln -sf ~/.config/udev/99-razer-ignore.rules /etc/udev/rules.d/99-razer-ignore.rules
sudo udevadm control --reload-rules
sudo udevadm trigger
```

### systemd (Lid Switch 無効化)

`/etc/systemd/logind.conf`

```ini
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
```

## Scripts

| スクリプト | 説明 |
|---|---|
| `term` | デフォルト端末 (Kitty) 起動。`--float` でフロートウィンドウ |
| `term_alacritty` | Alacritty 起動 |
| `change-brightness` | ddcutil + brightnessctl で輝度を統合制御 |
| `hm` | Home Manager ラッパー (`list` / `update`) |
| `chezmoi-sync-worktrees` | `wip/*` 以外の全 worktree を `local-applied` に合成 (`apply` の pre hook) |
| `chezmoi-route-changes` | `add` / `re-add` した差分を fzf で選んだ worktree へ移す (post hook) |

## Resources

- https://github.com/end-4/dots-hyprland
- https://github.com/JaKooLit/Hyprland-Dots
- https://github.com/fufexan/dotfiles
- https://github.com/MrVivekRajan/Hyprlock-Styles/
- https://github.com/D00cky/NaruMa/
- https://github.com/alpha2phi/modern-neovim
