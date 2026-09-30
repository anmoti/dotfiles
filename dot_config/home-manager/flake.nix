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

    flake-parts.follows = "llm-agents/flake-parts";

    llm-agents.url = "github:numtide/llm-agents.nix";

    mcp-servers.url = "github:natsukium/mcp-servers-nix";

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
            };
            llm-agents = llm-agents.packages.${system};
            mcp-hub = mcp-hub.packages.${system};
            local = {
              vscode-css-language-server = prev.callPackage ./pkgs/vscode-css-language-server/package.nix { };
              gtk-css-language-server = prev.callPackage ./pkgs/gtk-css-language-server/package.nix { };
              catppuccin-openbox = prev.callPackage ./pkgs/catppuccin-openbox/package.nix { };
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
