{
   programs.git = {
   enable = true;
   userName  = "michelav";
   userEmail = "michel.vasconcelos@gmail.com";
   aliases = {
     co = "checkout";
     graph = "log --decorate --oneline --graph";
   };
   extraConfig = {
    init = { defaultBranch = "main"; };
   };
   delta = {
      enable = true;
      options = {
         navigate = true;
         # line-numbers = true;
         syntax-theme = "Dracula";
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
