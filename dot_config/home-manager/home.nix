{ ... }:

{
  imports = [
    ./modules/base.nix
    ./modules/zsh.nix
  ];

  targets.genericLinux.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}

