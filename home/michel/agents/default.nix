# TODO: Add personal agents like hermes
_:
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
in
{
  home.file.".codex/AGENTS.md".text = globalAgentInstructions;
  home.file.".claude/CLAUDE.md".text = globalAgentInstructions;
  programs.codex = {
    enable = true;

    skills = nixSkills;

    # Do not manage config file. Let it be writable.
    settings = null;

    profiles.default = {
      approval_policy = "on-request";
      sandbox_mode = "workspace-write";
    };
  };

  # Use default profile
  programs.fish.shellAbbrs = {
    codex = "codex --profile default";
  };

  programs.claude-code = {
    enable = true;
    skills = nixSkills;
    settings = {
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
    };
  };
}
