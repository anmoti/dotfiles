{
  lib,
  config,
  pkgs,
  ...
}:

{
  imports = [
    ../modules/ai
  ];

  programs.neovim = {
    enable = true;
    package = pkgs.unstable.neovim-unwrapped;
    withRuby = false;
    withPython3 = true;
    sideloadInitLua = true;

    plugins = [ pkgs.vimPlugins.nvim-treesitter.withAllGrammars ];

    extraWrapperArgs = [
      "--run"
      "export HOST_PATH=$PATH"
      "--set"
      "PATH"
      (lib.makeBinPath (
        (with pkgs; [
          bash
          git # lazy.nvim bootstrap
          local.proto
          wl-clipboard # clipboard provider
        ])
        ++ (import ./neovim-deps.nix pkgs)
      ))
      "--run"
      ''
        if [ -z "$NIX_BUILD_TOP" ]; then
          eval "$(proto activate --export)"
        fi
      ''
    ];
  };

  programs.sioyek.enable = true;

  home.sessionVariables = {
    EDITOR = "${config.programs.neovim.finalPackage}/bin/nvim";
    VISUAL = "${config.programs.neovim.finalPackage}/bin/nvim";
  };
}
