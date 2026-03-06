{ pkgs, pkgu, lib, ... }:

{
  home.username = "anmoti";
  home.homeDirectory = "/home/anmoti";
  home.stateVersion = "25.11";

  home.packages = [
    # CLI Deps
    pkgs.oh-my-posh # zshrc
    pkgs.fd         # zshrc
    pkgs.fzf        # zshrc
    pkgs.bat        # zshrc
    pkgs.zoxide     # zshrc

    # GUI Deps
    pkgs.nwg-drawer # waybar

    # CLI Apps
    pkgu.chezmoi
  ];

  programs.home-manager.enable = true;

  programs.neovim = {
    enable = true;

    extraWrapperArgs = [
      "--run" "export HOST_PATH=$PATH"
      "--set" "PATH" (lib.makeBinPath [
        pkgs.bash
        pkgs.coreutils                    # sha256sum (blink.cmp)
        pkgs.curl
        pkgs.git
        pkgs.fd                           # Snacks.nvim
        pkgs.ripgrep                      # Snacks.nvim picker.grep()
        pkgs.wl-clipboard                 # clipboard provider

        pkgu.lua-language-server          # lua_ls
        pkgu.vscode-langservers-extracted # cssls eslint html jsonls
        pkgu.nixd                         # lsp nixd

        pkgu.chezmoi                      # chezmoi.nvim
      ])
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
