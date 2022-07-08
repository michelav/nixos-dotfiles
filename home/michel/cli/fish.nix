{ config, pkgs, ... }:
{
  programs = {
    fish = {
      enable = true;
      loginShellInit = builtins.readFile ../configs/fish/login.fish;
      shellAbbrs = {
        ls = "exa";
        cat = "bat";
        man = "man --pager=most";
        ndev = "nix develop -c $SHELL";
      };
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      settings = {
        username = {
          format = "[$user]($style)@";
          style_root = "bold red";
          show_always = true;
        };

        hostname = {
          format = "[$hostname]($style) in ";
          style = "bold dimmed green";
          trim_at = ".";
          ssh_only = false;
          disabled = false;
        };

        directory = {
          truncation_length = 2;
          truncate_to_repo = false;
          # truncation_symbol = "repo:";
          fish_style_pwd_dir_length = 1;
        };

        character = {
          error_symbol = "[~>](bold red)";
          success_symbol = "[->](bold dimmed green)";
          vicmd_symbol = "[<-](bold yellow)";
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
