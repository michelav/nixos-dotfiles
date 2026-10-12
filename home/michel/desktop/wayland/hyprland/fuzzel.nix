{
  config,
  ...
}:
{
  stylix.targets.fuzzel = {
    enable = true;
    # Keep the monospace launcher font below instead of Stylix's sans-serif.
    fonts.enable = false;
  };

  programs.fuzzel = {
    enable = true;
    settings =
      let
        fontName = config.stylix.fonts.monospace.name;
        fontSize = 12;
      in
      {
        main = {
          font = "${fontName}:size=${toString fontSize}";
          layer = "overlay";
          anchor = "top-left";
          use-bold = true;
          prompt = "\"  \"";
          horizontal-pad = 20;
          inner-pad = 5;
        };
      };
  };
}
