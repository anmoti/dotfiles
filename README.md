# dotfiles
My dotfiles.

# Require package

## hyprland

`hyprland`
`xdg-desktop-portal-hyprland`
`grim`
`slurp`
`hyprpicker`

`waybar`

`fcitx5-im`
- `fcitx5-mozc-ut`
- `fcitx5-skk`

`alacritty`
`nemo`
`fuzzel`
`vivaldi`

...

## ddcutil

```bash
echo 'SUBSYSTEM=="i2c-dev", KERNEL=="i2c-[0-9]*", GROUP="i2c"' > /etc/udev/rules.d/45-myi2c.rules
sudo groupadd --system i2c
sudo usermod -aG i2c $USER
```

https://www.ddcutil.com/i2c_permissions_using_group_i2c/

## udev

Razer BlackWidow Elite の音量ダイヤルが終わってるので無視する
```bash
sudo mkdir -p /etc/udev/rules.d/
sudo ln -sf ~/.config/udev/99-razer-ignore.rules /etc/udev/rules.d/99-razer-ignore.rules

sudo udevadm control --reload-rules
sudo udevadm trigger
```
