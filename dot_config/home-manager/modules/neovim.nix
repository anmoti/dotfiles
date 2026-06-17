{ lib, pkgs, pkgu, packages, ... }:

{
  programs.neovim = {
    enable = true;
    package = pkgu.neovim-unwrapped;
    withRuby = false;
    withPython3 = false;
    sideloadInitLua = true;

    plugins = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      # markup
      markdown
      markdown_inline
      html
      latex
      xml
      # code
      c
      cpp
      go
      c_sharp
      python
      php
      javascript
      typescript
      tsx
      svelte
      astro
      css
      # scripting
      bash
      lua
      nix
      dockerfile
      # config
      ini
      json
      json5
      toml
      yaml
      hcl
      # neovim internals
      vim
      vimdoc
      regex
      query
    ];

    defaultEditor = true;
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

        pkgs.bash-language-server           # neovim_lsp[bashls]
        pkgs.lua-language-server            # neovim_lsp[lua_ls]
        pkgs.yaml-language-server           # neovim_lsp[yamlls]
        pkgs.taplo                          # neovim_lsp[taplo]
        packages.gtk-css-language-server    # neovim_lsp[gtkcssls]
        packages.vscode-css-language-server # neovim_lsp[cssls]
        pkgs.vscode-langservers-extracted   # neovim_lsp[cssls, eslint, html, jsonls]
        pkgs.basedpyright                   # neovim_lsp[basedpyright(basedpyright-langserver)]
        pkgs.ruff                           # neovim_lsp[ruff]
        pkgs.mypy                           # nvim-lsp[mypy]
        pkgs.nixd                           # neovim_lsp[nixd]
        pkgs.docker-language-server         # neovim_lsp[docker-language-server]
        pkgs.opentofu                       # neovim_lsp[tofu_ls] (schema, format)
        pkgs.tofu-ls                        # neovim_lsp[tofu_ls]
        pkgs.kdePackages.qtdeclarative      # neovim_lsp[qmlls]
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
    ];
  };

  programs.sioyek.enable = true;
}
