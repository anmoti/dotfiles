{ pkgs, agent, ... }:

let
  context = ./AGENTS.md;
  skills = import ./skills { inherit (pkgs) lib; };
in
{
  imports = [
    agent.mcps.homeManagerModules.default
  ];

  # `hm skills` runs npins against modules/ai/npins.
  home.packages = [ pkgs.npins ];

  programs.mcp.enable = true;

  mcp-servers.programs = {
    playwright.enable = true;
    context7 = {
      enable = true;
      # nixos-26.05 の pnpm_10 が insecure 扱いのため、mcp-servers-nix が自前の nixpkgs でビルドしたものを使う
      package = pkgs.mcp-servers.context7-mcp;
      passwordCommand = ''echo "TEST_KEY"'';
    };
  };

  programs.claude-code = {
    enable = true;
    package = pkgs.llm-agents.claude-code;
    enableMcpIntegration = true;
    inherit context skills;
  };

  programs.opencode = {
    enable = true;
    package = pkgs.llm-agents.opencode2;
    enableMcpIntegration = true;
    inherit context skills;
  };

  programs.antigravity-cli = {
    enable = true;
    package = pkgs.llm-agents.antigravity-cli;
    enableMcpIntegration = true;
    context.AGENTS = context;
    inherit skills;
  };

  home.shellAliases.opencode = "opencode2";
}
