{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      system = "x86_64-linux";

      config = {
        allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
          "copilot-language-server"
          "terraform"
        ];
      };

      pkgs = import nixpkgs {
        inherit system config;
      };
      pkgu = import nixpkgs-unstable {
        inherit system config;
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
      };
    in {
      packages.${system} = localPackages;

      homeConfigurations."anmoti" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit pkgu; packages = localPackages; };
        modules = [ ./home.nix ];
      };
    };
}
