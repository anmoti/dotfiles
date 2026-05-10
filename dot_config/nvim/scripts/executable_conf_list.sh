#!/usr/bin/env bash

fd_options=(
  . "$HOME/.config"
  --type file
  --type directory
  --hidden --no-ignore
            # Custom
  --exclude "/winapps/images/efi*"
            # General
  --exclude "/.*"
            # General (Data)
  --exclude "*{[Cc]ache,[Cc]rash}*/"
  --exclude "cached*"
  --exclude "backups/"
  --exclude "logs/"
  --exclude "*.log"
  --exclude "tmp/"
  --exclude "recent*"
  --exclude "*history"
  --exclude "*.{db,boltdb,sqlite*}"
  --exclude "*.pem"
            # General (State)
  --exclude "*WindowState"
  --exclude "*.{lock,last}"
  --exclude "*-lock.json"
  --exclude "*~"
            # Service
  --exclude "/systemd/"
  --exclude "/autostart/"
  --exclude "/mozc/"
  --exclude "/dconf/user"
  --exclude "/pulse/cookie"
  --exclude "/ibus/bus/"
  --exclude "/fcitx/dbus/"
  --exclude "/libvirt/qemu/"
  --exclude "/QtProject*"
  --exclude "/astro/"
  --exclude "/coderabbit/"
  --exclude "/gh/hosts.yml"
  --exclude "/github-copilot/"
  --exclude "/{go,gopls}/"
  --exclude "/menus/"
  --exclude "/pdfcpu/certs/"
  --exclude "/unity3d/"
            # GUI App
  --exclude "/{google-chrome*,chromium}/"
  --exclude "/microsoft-edge*/"
  --exclude "/vivaldi*/"
  --exclude "/BraveSoftware/Brave-Browser/"
  --exclude "/YouTube Music/"
  --exclude "/1Password/{files,drafts}"
  --exclude "/Bitwarden/"
  --exclude "/Insomnia/"
  --exclude "/GIMP/3.0/{theme.css,*.xml,internal-data}"
  --exclude "/containers/podman-desktop/"
  --exclude "/filezilla/"
  --exclude "/font-manager/"
  --exclude "/ghidra/"
  --exclude "/legcord/storage/"
  --exclude "/legcord/{shelter.js,equicord.*s,vencord.*s}"
  --exclude "/libreoffice/"
  --exclude "/obs-studio/profiler_data/"
  --exclude "/polychromatic/{backends,devices,states}/"
  --exclude "/teams-for-linux/"
  --exclude "/unityhub"
  --exclude "/{Code,Antigravity}/*/{History,sync}/"
  --exclude "/{Code,Antigravity}/{Backups,clp}/"
  --exclude "/{Code,Antigravity}/User/{global,workspace}Storage"
  --exclude "/{Code,Antigravity}/languagepacks.json"
  --exclude "/vscode-*/"
  --exclude "{Rider,AndroidStudio}*/"
            # Chromium, Electron
  --exclude "{Local,Session} Storage/"
  --exclude "Shared Dictionary/"
  --exclude "Service Worker/"
  --exclude "Dictionaries/"
  --exclude "Partitions/"
  --exclude "IndexedDB/"
  --exclude "blob_storage/"
  --exclude "shared_proto_db/"
  --exclude "VideoDecodeStats/"
  --exclude "WebrtcVideoStats/"
  --exclude "WebStorage/"
  --exclude ".org.chromium.Chromium.*"
  --exclude "SharedStorage*"
  --exclude "Trust Tokens*"
  --exclude "Cookies*"
  --exclude "DIPS*"
  --exclude "Network Persistent State"
  --exclude "TransportSecurity"
  --exclude "Preferences"
  --exclude "machineid"
  --exclude "electron-log-preload.js"

  --color never
)

{
  fd "${fd_options[@]}"
  chezmoi managed --include files --path-style absolute
} | sort -u

