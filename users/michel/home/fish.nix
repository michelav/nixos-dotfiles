{ config, pkgs, ... }:
{
  programs = {
    fish.enable = true;

    starship = {
      enable = true;
      settings = {
        username = {
          format = "[── $user]($style)@";
          style_user = "bold blue";
          style_root = "bold red";
          show_always = true;
        };

        hostname = {
          format = "[$hostname]($style) in ";
          style = "bold dimmed blue";
          trim_at = "-";
          ssh_only = false;
          disabled = false;
        };

        directory = {
          truncation_length = 0;
          truncate_to_repo = true;
          truncation_symbol = "repo:";
        };

        aws.symbol = "  ";
        buf.symbol = " ";
        conda.symbol = " ";
        dart.symbol = " ";
        directory.read_only = " ";
        docker_context.symbol = " ";
        elixir.symbol = " ";
        elm.symbol = " ";
        git_branch.symbol = " ";
        golang.symbol = " ";
        haskell.symbol = " ";
        hg_branch.symbol = " ";
        java.symbol = " ";
        julia.symbol = " ";
        memory_usage.symbol = " ";
        nim.symbol = " ";
        nix_shell.symbol = " ";
        nodejs.symbol = " ";
        package.symbol = " ";
        rust.symbol = " ";
      };
    };
  };
}