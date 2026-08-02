# TODO: Add personal agents like hermes
_: {
  programs.codex = {
    enable = true;

    settings = {
      approval_policy = "on-request";
      sandbox_mode = "workspace-write";
    };
  };

  programs.claude-code = {
    enable = true;

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
