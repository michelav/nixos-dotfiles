{ pkgs, ... }: {
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "michelav";
    userEmail = "michel.vasconcelos@gmail.com";
    aliases = {
      co = "checkout";
      graph = "log --decorate --oneline --graph";
      st = "status";
    };
    extraConfig = {
      init = { defaultBranch = "main"; };
      credential = {
        "https://github.com" = { helper = "!pass GitHub/michelav"; };
      };
    };
    ignores = [ "result" ".direnv" ];
    signing = {
      signByDefault = true;
      key = "60193619FE330051";
    };
    delta = {
      enable = true;
      options = {
        navigate = true;
        # line-numbers = true;
        syntax-theme = "Nord";
        features = "side-by-side line-numbers decorations";
        plus-style = "syntax #003800";
        minus-style = "syntax #3f0001";
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-style = "bold yellow ul";
          file-decoration-style = "none";
          hunk-header-decoration-style = "cyan box ul";
        };
        line-numbers = {
          line-numbers-left-style = "cyan";
          line-numbers-right-style = "cyan";
          line-numbers-minus-style = 124;
          line-numbers-plus-style = 28;
        };
      };
    };
  };
}
