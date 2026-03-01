#!/usr/bin/env bash

{
  fd . "$HOME/.config"                                  \
    --type file                                         \
    --type directory                                    \
    --hidden --no-ignore                                \
    --exclude "/mozc/"                                  \
    --exclude "/systemd/"                               \
    --exclude "/dconf/user/"                            \
    --exclude "/pulse/cookie"                           \
    --exclude "/ibus/bus/"                              \
    --exclude "/fcitx/dbus/"                            \
    --exclude "/libvirt/qemu/"                          \
    --exclude "/unity3d/"                               \
    --exclude "/{vivaldi*,google-chrome}/"              \
    --exclude "/teams-for-linux/"                       \
    --exclude "/legcord/storage/"                       \
    --exclude "/1Password/{drafts,files}/"              \
    --exclude "/polychromatic/"                         \
    --exclude "/winapps/images/efi*"                    \
    --exclude "/Insomnia/{backups,responses,sentry}/"   \
    --exclude "/{Code,Antigravity}/*/{History,sync}/"   \
    --exclude "/{Code,Antigravity}/{Backups,clp}/"      \
    --exclude "{global,workspace,local,Web}Storage/"    \
    --exclude "{Local,Session} Storage"                 \
    --exclude "Shared Dictionary/"                      \
    --exclude "{blob}_storage/"                         \
    --exclude "Service Worker/"                         \
    --exclude "Dictionaries/"                           \
    --exclude "Partitions/"                             \
    --exclude "IndexedDB/"                              \
    --exclude "*[Cc]ache*/"                             \
    --exclude "shared_proto_db/"                        \
    --exclude "VideoDecodeStats/"                       \
    --exclude "WebrtcVideoStats/"                       \
    --exclude "Crashpad/"                               \
    --exclude "logs/"                                   \
    --exclude "telemetry"                               \
    --exclude "*WindowState"                            \
    --exclude "*.{db,boltdb,sqlite*,lock,ipc,pem,log}"  \
    --exclude "*-lock.json"                             \
    --exclude "*~"                                      \
    --exclude ".org.chromium.Chromium.*"                \
    --exclude "SharedStorage*"                          \
    --exclude "Trust Tokens*"                           \
    --exclude "Cookies*"                                \
    --exclude "DIPS*"                                   \
    --exclude "Network Persistent State"                \
    --exclude "TransportSecurity"                       \
    --exclude "Preferences"                             \
    --exclude "machineid"                               \
    --exclude "electron-log-preload.js"                 \
    --color never
  
  chezmoi managed --include files --path-style absolute
} | sort -u

