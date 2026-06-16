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

## Resources

- https://github.com/end-4/dots-hyprland
- https://github.com/JaKooLit/Hyprland-Dots
- https://github.com/fufexan/dotfiles
- https://github.com/MrVivekRajan/Hyprlock-Styles/
- https://github.com/D00cky/NaruMa/
- https://github.com/alpha2phi/modern-neovim
