{ pkgs, agent, ... }:

{
  imports = [
    agent.mcps.homeManagerModules.default
    agent.skills.homeManagerModules.default
  ];

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
  };

  programs.opencode = {
    enable = true;
    package = pkgs.llm-agents.opencode2;
    enableMcpIntegration = true;
  };

  programs.agent-skills = {
    enable = true;
    sources = pkgs.agentSkills;
    skills = {
      enable = with pkgs.agentSkills; [
        local
      ];

      # Claude Code only discovers skills/<name>/SKILL.md.
      flatten = true;
    };
  };

  home.shellAliases.opencode = "opencode2";
}
