{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.follows = "llm-agents/flake-parts";

    llm-agents.url = "github:numtide/llm-agents.nix";

    mcp-servers.url = "github:natsukium/mcp-servers-nix";

    # 2.9.3 contains the completion retrigger fix (#887, #888); drop once nixpkgs ships >= 2.9.3
    nixd = {
      url = "github:nix-community/nixd/2.9.3";
      inputs.flake-parts.follows = "flake-parts";
    };

    mcp-hub = {
      url = "github:ravitemer/mcp-hub";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      llm-agents,
      mcp-servers,
      mcp-hub,
      nixd,
      ...
    }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfreePredicate =
            pkg:
            builtins.elem (nixpkgs.lib.getName pkg) [
              "claude-code"
            ];
        };
        overlays = [
          (final: prev: {
            unstable = import nixpkgs-unstable {
              inherit system;
              config = prev.config;
              overlays = [
                (uFinal: uPrev: {
                  nixd =
                    if prev.lib.versionAtLeast uPrev.nixd.version "2.9.3" then
                      prev.lib.warn
                        "nixpkgs-unstable now provides nixd >= 2.9.3 (${uPrev.nixd.version}); you can drop the custom nixd flake input."
                        uPrev.nixd
                    else
                      nixd.packages.${system}.nixd;
                 })
              ];
            };
            llm-agents = llm-agents.packages.${system};
            mcp-hub = mcp-hub.packages.${system};
            local = {
              nixd = nixd.packages.${system}.nixd;
              vscode-css-language-server = prev.callPackage ./pkgs/vscode-css-language-server/package.nix { };
              gtk-css-language-server = prev.callPackage ./pkgs/gtk-css-language-server/package.nix { };
              catppuccin-openbox = prev.callPackage ./pkgs/catppuccin-openbox/package.nix { };
              # Patches target labwc/wlroots 0.20.2
              nestwm = prev.callPackage ./pkgs/nestwm/package.nix {
                inherit (final.unstable) labwc wlroots_0_20;
              };
              proto = prev.callPackage ./pkgs/proto/package.nix { package = final.unstable.proto; };
              wallpapers =
                let
                  wallpaperDir = ./pkgs/wallpapers;
                  files = builtins.readDir wallpaperDir;
                in
                prev.lib.pipe files [
                  (prev.lib.filterAttrs (name: type: type == "regular" && prev.lib.hasSuffix ".nix" name))
                  builtins.attrNames
                  (map (name: prev.callPackage (wallpaperDir + "/${name}") { }))
                ];
            };
          })
        ];
      };

      findNixFiles =
        dir:
        pkgs.lib.pipe (builtins.readDir dir) [
          (pkgs.lib.filterAttrs (name: type: type == "regular" && pkgs.lib.hasSuffix ".nix" name))
          (pkgs.lib.mapAttrsToList (name: _: dir + "/${name}"))
        ];
    in
    {
      formatter.${system} = pkgs.nixfmt-tree;

      packages.${system} = pkgs.lib.filterAttrs (_: pkgs.lib.isDerivation) pkgs.local;

      homeConfigurations.lsp = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit mcp-servers; };
        modules = [ ./home.nix ] ++ (findNixFiles ./profiles);
      };

      homeConfigurations."anmoti" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit mcp-servers; };
        modules = [ ./home.nix ];
      };

      homeConfigurations."anmoti@LEGION5" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit mcp-servers; };
        modules = [
          ./home.nix
          ./profiles/desktop.nix
        ];
      };

      homeConfigurations."anmoti@thinkpad-1" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit mcp-servers; };
        modules = [
          ./home.nix
          ./profiles/desktop.nix
        ];
      };
    };
}
