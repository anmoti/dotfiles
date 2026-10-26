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

    # Fork of Kyure-A/agent-skills-nix (selector tree, flatten, exclude, HM target linkage).
    agent-skills = {
      url = "github:anmoti/agent-skills-nix";
      inputs.nixpkgs.follows = "nixpkgs";
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
      agent-skills,
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
            mcp-servers = mcp-servers.packages.${system};
            mcp-hub = mcp-hub.packages.${system};
            # Under pkgs so that nixd (which only completes from pkgs/lib) can complete skill names.
            agentSkills = agent.skillsLib.sourcesFromLock {
              manifestsDir = ./registries/skills/sources;
              lockFile = ./registries/skills/sources.lock.json;
            } // {
              local = agent.skillsLib.mkSourceTree "local" {
                path = ./registries/skills/local;
                filter.maxDepth = 1;
              };
            };
            local = {
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

      agent = {
        skills = agent-skills;
        skillsLib = agent-skills.lib.agent-skills;
        mcps = mcp-servers;
      };

      # Update registries/skills/sources.lock.json (`nix run .#skills-sources-lock` from dot_config/home-manager).
      # npins comes from unstable: nixos-26.05's 0.4.2 writes lock version 7, but agent-skills-nix requires 8.
      # These must be relative strings: the lock program writes to them, and a path literal resolves into the read-only store.
      sourceLockProgram = agent.skillsLib.mkSourceLockProgram {
        inherit pkgs;
        npins = pkgs.unstable.npins;
        manifestsDir = "registries/skills/sources";
        lockFile = "registries/skills/sources.lock.json";
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

      # Update registries/skills/sources.lock.json for the sources declared in registries/skills/sources.
      # Run from dot_config/home-manager: nix run .#skills-sources-lock
      apps.${system}.skills-sources-lock = {
        type = "app";
        program = "${sourceLockProgram}/bin/skills-sources-lock";
      };

      packages.${system} = pkgs.lib.filterAttrs (_: pkgs.lib.isDerivation) pkgs.local;

      homeConfigurations.lsp = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit agent; };
        modules = [ ./home.nix ] ++ (findNixFiles ./profiles);
      };

      homeConfigurations."anmoti" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit agent; };
        modules = [ ./home.nix ];
      };

      homeConfigurations."anmoti@LEGION5" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit agent; };
        modules = [
          ./home.nix
          ./profiles/desktop.nix
        ];
      };

      homeConfigurations."anmoti@legion5-arch" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit agent; };
        modules = [
          ./home.nix
          ./profiles/desktop.nix
        ];
      };

      homeConfigurations."anmoti@thinkpad-1" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit agent; };
        modules = [
          ./home.nix
          ./profiles/desktop.nix
        ];
      };
    };
}
