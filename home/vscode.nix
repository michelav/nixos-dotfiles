{ config, pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    package = pkgs.vscode-fhs;
    userSettings = {
      "editor.renderWhitespace" = "all";
      "editor.rulers" = [ 80 120 ];
      "editor.tabSize" = 2;
      "editor.fontLigatures" = true;
      "workbench.fontAliasing" = "antialiased";
      "workbench.colorTheme" = "Catppuccin";
      "files.trimTrailingWhitespace" = true;
      "workbench.iconTheme" = "vscode-icons";
    };

    extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      eamodio.gitlens
      ms-python.python
      ms-vscode-remote.remote-ssh
      # Catppuccin.catppuccin-vsc
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "catppuccin-vsc";
        publisher = "Catppuccin";
        version = "1.0.6";
        sha256 = "sha256-4M8y8dc8BpH1yhabYJsHDT9uDWeqYjnvPBgLS+lTa5I";
      }
      {
        name = "remote-containers";
        publisher = "ms-vscode-remote";
        version = "0.232.6";
        sha256 = "sha256-LoO2YATrqwpxFX/4VpsBbVgsmYjFELNKAnQV0UcBico=";
        # sha256 = pkgs.lib.stdenv.lib.fakeSha256;
      }
    ];
  };
}