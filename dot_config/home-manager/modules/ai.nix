{ config, pkgs, agent, ... }:

{
  imports = [
    agent.mcps.homeManagerModules.default
    agent.skills.homeManagerModules.default
  ];

  programs.agent-skills = {
    enable = true;
    targets = {
      claude.enable = config.programs.claude-code.enable;
      opencode.enable = config.programs.opencode.enable;
    };
    sources.local.path = ../skills;
    skills.enableAll = [ "local" ];
  };

  programs.mcp.enable = true;

  mcp-servers.programs = {
    playwright.enable = true;
    context7 = {
      enable = true;
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

  home.shellAliases.opencode = "opencode2";
}
