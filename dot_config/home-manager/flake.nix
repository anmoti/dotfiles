{
  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, llm-agents, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
      };
      pkgu = import nixpkgs-unstable {
        inherit system;
      };

      wallpaperPkgs =
        let
          wallpaperDir = ./pkgs/wallpapers;
          files = builtins.readDir wallpaperDir;
        in
        pkgs.lib.pipe files [
          (pkgs.lib.filterAttrs (name: type:
            type == "regular" && pkgs.lib.hasSuffix ".nix" name
          ))
          builtins.attrNames
          (map (name: pkgs.callPackage (wallpaperDir + "/${name}") {}))
        ];

      localPackages = {
        vscode-css-language-server = pkgs.callPackage ./pkgs/vscode-css-language-server/package.nix {};
        gtk-css-language-server = pkgs.callPackage ./pkgs/gtk-css-language-server/package.nix {};
        wallpapers = wallpaperPkgs;
        claude-code = llm-agents.packages.${system}.claude-code;
        copilot-language-server = llm-agents.packages.${system}.copilot-language-server;
      };
    in {
      packages.${system} = pkgs.lib.filterAttrs (_: pkgs.lib.isDerivation) localPackages;

      homeConfigurations."anmoti" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit pkgu; packages = localPackages; };
        modules = [ ./home.nix ];
      };

      homeConfigurations."anmoti@LEGION5" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit pkgu; packages = localPackages; };
        modules = [ ./home.nix ./profiles/desktop.nix ];
      };
    };
}
