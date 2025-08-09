_: {
  programs = {
    fish = {
      enable = true;
      interactiveShellInit = builtins.readFile ../configs/fish/login.fish;
      loginShellInit = ''
        if test (tty) = /dev/tty1
          uwsm start hyprland-uwsm.desktop
        end
      '';
      shellAbbrs = {
        cat = "bat";
        nd = {
          position = "command";
          expansion = "nix develop .#% -c $SHELL";
          setCursor = true;
        };
        nsh = {
          position = "command";
          expansion = "nix shell nixpkgs#% -c $SHELL";
          setCursor = true;
        };
        gits = "git status";
      };
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      settings = {
        format =
          let
            git = "$git_branch$git_commit$git_state$git_status";
            cloud = "$aws$gcloud$azure";
            langs = "$c$cmake$dotnet$elixir$elm$erlang$golang$haskell$helm$java$julia$kotlin$lua$nodejs$ocaml$perl$pulumi$purescript$python$rlang$ruby$rust$scala";
          in
          ''
            ($all)$username$hostname$directory$shlvl${git} $cmd_duration(
            ${cloud})(
            $nix_shell $package $terraform ${langs})
            $jobs$character'';
        username = {
          format = "[$user]($style)@";
          style_root = "bold red";
          show_always = true;
        };

        hostname = {
          format = "[$hostname]($style) in ";
          style = "bold green";
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
          success_symbol = "[->](bold green)";
          vicmd_symbol = "[<-](bold yellow)";
        };
        nix_shell = {
          format = "via [$symbol($name)(\\[$state\\])]($style)";
          style = "bold blue";
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
        memory_usage.symbol = "󰍛 ";
        nim.symbol = " ";
        nix_shell.symbol = " ";
        nodejs.symbol = " ";
        package.symbol = "󰏗 ";
        rust.symbol = " ";
      };
    };
  };
}
