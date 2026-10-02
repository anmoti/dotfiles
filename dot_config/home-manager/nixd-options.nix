let
  # nixf falsely reports `getFlake` as an unknown builtin (nix-community/nixd#762);
  # the dynamic attr avoids it. Switch back to `builtins.getFlake` once fixed.
  flake = builtins.${"getFlake"} "path:${toString ./.}";
  nixpkgs = flake.inputs.nixpkgs.legacyPackages.x86_64-linux;
  hm = flake.homeConfigurations.lsp.options;
  mcp = (flake.inputs.mcp-servers.lib.evalModule nixpkgs { }).options;
in
{
  inherit nixpkgs;
  # mcp-servers.programs is `attrsOf anything` upstream, which crashes nixd;
  # swap in the typed options instead.
  home-manager = hm // { mcp-servers = hm.mcp-servers // { programs = mcp.programs; }; };
}
