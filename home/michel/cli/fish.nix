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
      functions = {
        gitignore = "curl -sL https://www.gitignore.io/api/$argv";
        ffp = {
          body = ''
            begin; if git rev-parse --is-inside-work-tree >/dev/null 2>&1; and git ls-files -co --exclude-standard -z; else; fd -0 --type f --hidden --follow --exclude .git .; end; end \
            | fzf --read0 --print0 --ansi --height=80% --preview 'bat --color=always --style=numbers,header --line-range :200 {} 2>/dev/null || head -n200 {}' \
            | xargs -0 -r nvim
          '';
        };
        frg = {
          body = ''
            rg -n --no-heading --hidden -g '!.git' --color=always "" \
            | fzf --ansi --delimiter : --preview 'bat --color=always --style=numbers --highlight-line {2} {1} 2>/dev/null' \
            | awk -F: '{print "+"$2, $1}' \
            | xargs -r nvim
          '';
        };
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
