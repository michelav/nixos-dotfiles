# TODO: Add personal agents like hermes
{ lib, pkgs, ... }:
let
  globalAgentInstructions = ''
    # Global agent guidance

    ## Efficiency

    - Communicate concisely; do not restate the request or narrate routine actions.
    - Search and inspect narrowly before reading large files or broad directory trees.
    - Prefer focused command output and targeted checks over verbose logs.
    - Do not repeat file contents or explanations already present in the conversation.
    - Report decisions, changed files, validation results, risks, and blockers.
    - Preserve necessary detail for architecture, security, destructive actions, and complex trade-offs.
  '';
  nixSkills = {
    nix-change = ./skills/nix-change;
    nix-diagnose = ./skills/nix-diagnose;
  };
  claudeSettings = pkgs.writeText "claude-code-user-settings.json" (
    builtins.toJSON {
      "$schema" = "https://json.schemastore.org/claude-code-settings.json";
      theme = "auto";
      permissions = {
        defaultMode = "default";

        deny = [
          "Read(./.env)"
          "Read(./.env.*)"
          "Read(./secrets/**)"
          "Read(./credentials/**)"
        ];

        ask = [
          "Bash(curl *)"
          "Bash(wget *)"
          "Bash(git push *)"
          "Bash(sudo *)"
          "Bash(nix flake update *)"
        ];

        allow = [
          "Bash(git status)"
          "Bash(git diff *)"
          "Bash(git log *)"
          "Bash(nix flake check *)"
          "Bash(nix fmt *)"
        ];
      };
      includeCoAuthoredBy = false;
    }
  );
in
{
  home.packages = [ pkgs.bubblewrap ];
  # Preserve mutable agent state and manually installed skills.
  # Home Manager continues managing its symlinks within these directories.
  home.persistence."/persist" = {
    directories = [
      ".codex"
      ".claude"
      ".agents"
    ];
    files = [ ".claude.json" ];
  };

  home.file.".codex/AGENTS.md".text = globalAgentInstructions;
  home.file.".claude/CLAUDE.md".text = globalAgentInstructions;

  # Seed user settings once, then let Claude Code update them. Managing this
  # file as a Home Manager symlink prevents /config and /model from persisting.
  home.activation.claudeCodeUserSettings = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    settings="$HOME/.claude/settings.json"
    $DRY_RUN_CMD mkdir -p "$HOME/.codex/themes"
    if [ ! -e "$settings" ]; then
      $DRY_RUN_CMD mkdir -p "$(dirname "$settings")"
      $DRY_RUN_CMD ${pkgs.coreutils}/bin/install -m 600 ${claudeSettings} "$settings"
    fi
  '';

  programs.codex = {
    enable = true;
    package = (
      pkgs.codex.overrideAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) ++ [
          pkgs.aws-lc
          pkgs.oniguruma
          pkgs.sqlite
          pkgs.zstd
        ];
      })
    );

    skills = nixSkills;

    # Do not manage config file. Let it be writable.
    settings = null;
  };

  programs.claude-code = {
    enable = true;
    skills = nixSkills;
    settings = { };
  };
}
