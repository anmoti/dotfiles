{
  lib,
  config,
  pkgs,
  ...
}:

{
  imports = [
    ../modules/ai.nix
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
        with pkgs;
        [
          bash
          coreutils # sha256sum (blink.cmp), tee (:SudoWrite)
          curl
          git
          git-lfs # git status in LFS repos (filter.lfs.required)
          fd # Snacks.nvim
          ripgrep # Snacks.nvim picker.grep()
          doppler # codecompanion (api_key)

          bash-language-server # lspconfig[bashls]
          lua-language-server # lspconfig[lua_ls]
          stylua # conform[lua]
          yaml-language-server # lspconfig[yamlls]
          taplo # lspconfig[taplo]
          local.gtk-css-language-server # lspconfig[gtkcssls]
          local.vscode-css-language-server # lspconfig[cssls]
          vscode-langservers-extracted # lspconfig[cssls, eslint, html, jsonls]
          basedpyright # lspconfig[basedpyright(basedpyright-langserver)]
          ruff # lspconfig[ruff]
          # mypy                               # nvim-lint[mypy]
          typescript-go # lspconfig[tsc]
          svelte-language-server # lspconfig[svelte]
          unstable.astro-language-server # lspconfig[astro]
          tailwindcss-language-server # lspconfig[tailwindcss]
          gopls # lspconfig[gopls]
          rustup # lspconfig[rust_analyzer]
          nixd # lspconfig[nixd]
          docker-language-server # lspconfig[docker-language-server]
          opentofu # lspconfig[tofu_ls] (schema, format)
          tofu-ls # lspconfig[tofu_ls]
          kdePackages.qtdeclarative # lspconfig[qmlls]
          buf # lspconfig[buf_ls]

          local.proto

          mcp-hub.mcp-hub # mcphub.nvim
          llm-agents.copilot-language-server # copilot.lua
          llm-agents.claude-code # claudecode.nvim

          sioyek # VimTeX
          (texlive.combine {
            inherit (texlive)
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

          unstable.chezmoi # chezmoi.nvim
          unstable.wakatime-cli # vim-wakatime
        ]
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
