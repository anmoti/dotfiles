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
    waylandSupport = true;
    sideloadInitLua = true;

    extraPython3Packages =
      ps: with ps; [
        jupyter-client # molten-nvim
        cairosvg # molten-nvim
        pnglatex # molten-nvim
        plotly # molten-nvim
        kaleido # molten-nvim
        pyperclip # molten-nvim
        nbformat # molten-nvim
        pillow # molten-nvim
      ];

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
