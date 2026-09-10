{ lib, config, pkgs, pkgu, packages, ... }:

{
  imports = [
    ../modules/ai.nix
  ];

  programs.neovim = {
    enable = true;
    package = pkgu.neovim-unwrapped;
    withRuby = false;
    withPython3 = true;
    sideloadInitLua = true;

    extraPython3Packages = ps: with ps; [
      jupyter-client  # molten-nvim
      cairosvg        # molten-nvim
      pnglatex        # molten-nvim
      plotly          # molten-nvim
      kaleido         # molten-nvim
      pyperclip       # molten-nvim
      nbformat        # molten-nvim
      pillow          # molten-nvim
    ];

    plugins = [ pkgs.vimPlugins.nvim-treesitter.withAllGrammars ];

    extraWrapperArgs = [
      "--run" "export HOST_PATH=$PATH"
      "--set" "PATH" (lib.makeBinPath [
        pkgs.bash
        pkgs.coreutils                      # sha256sum (blink.cmp), tee (:SudoWrite)
        pkgs.curl
        pkgs.git
        pkgs.fd                             # Snacks.nvim
        pkgs.ripgrep                        # Snacks.nvim picker.grep()
        pkgs.wl-clipboard                   # clipboard provider
        pkgs.doppler                        # codecompanion (api_key)

        pkgs.bash-language-server           # lspconfig[bashls]
        pkgs.lua-language-server            # lspconfig[lua_ls]
        pkgs.stylua                         # conform[lua]
        pkgs.yaml-language-server           # lspconfig[yamlls]
        pkgs.taplo                          # lspconfig[taplo]
        packages.gtk-css-language-server    # lspconfig[gtkcssls]
        packages.vscode-css-language-server # lspconfig[cssls]
        pkgs.vscode-langservers-extracted   # lspconfig[cssls, eslint, html, jsonls]
        pkgs.basedpyright                   # lspconfig[basedpyright(basedpyright-langserver)]
        pkgs.ruff                           # lspconfig[ruff]
        # pkgs.mypy                           # nvim-lint[mypy]
        pkgs.typescript-go                  # lspconfig[tsc]
        pkgs.svelte-language-server         # lspconfig[svelte]
        pkgu.astro-language-server          # lspconfig[astro]
        pkgs.gopls                          # lspconfig[gopls]
        pkgs.rustup                         # lspconfig[rust_analyzer]
        pkgs.nixd                           # lspconfig[nixd]
        pkgs.docker-language-server         # lspconfig[docker-language-server]
        pkgs.opentofu                       # lspconfig[tofu_ls] (schema, format)
        pkgs.tofu-ls                        # lspconfig[tofu_ls]
        pkgs.kdePackages.qtdeclarative      # lspconfig[qmlls]

        packages.proto

        packages.mcp-hub                    # mcphub.nvim
        packages.copilot-language-server    # copilot.lua
        packages.claude-code                # claudecode.nvim

        pkgs.sioyek                         # VimTeX
        (pkgs.texlive.combine {
          inherit (pkgs.texlive)
            scheme-small
            collection-latexextra
            collection-fontsrecommended
            collection-langjapanese
            tikz-cd
            circuitikz
            siunitx
            biber
            latexmk
            ;
         })

        pkgu.chezmoi                        # chezmoi.nvim
        pkgu.wakatime-cli                   # vim-wakatime
      ])
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
