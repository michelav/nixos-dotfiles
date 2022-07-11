{ pkgs, inputs, ... }:
{
  programs.nnn = {
    enable = true;
    package = pkgs.nnn.override ({ withNerdIcons = true; });
    bookmarks = {
      d = "~/dev";
      D = "~/Downloads";
      m = "/media/";
      b = "~/Dropbox/";
    }; 
    extraPackages = with pkgs; [ 
      ffmpegthumbnailer 
      mediainfo 
      sxiv 
      exa
      fzf 
    ];
  plugins = {
    src = "${inputs.nnn-plugins}/plugins";
    mappings = {
        c = "fzcd";
        f = "finder";
        o = "fzopen";
        p = "preview-tui";
        t = "nmount";
        v = "imgview";
      };
    };
  };
}
