{ packages, mcp-servers, ... }:

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
    package = packages.claude-code;
    enableMcpIntegration = true;
  };

  programs.opencode = {
    enable = true;
    package = packages.opencode;
    enableMcpIntegration = true;
  };
}
