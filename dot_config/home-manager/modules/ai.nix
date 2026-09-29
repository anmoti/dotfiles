{ pkgs, mcp-servers, ... }:

{
  imports = [ mcp-servers.homeManagerModules.default ];

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
    package = pkgs.llm-agents.opencode;
    enableMcpIntegration = true;
  };
}
