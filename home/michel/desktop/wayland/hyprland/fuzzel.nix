{
  config,
  ...
}:
{
  programs.fuzzel = {
    enable = true;
    settings =
      let
        fontName = config.userPrefs.fonts.monospace.name;
        fontSize = 12;
        icon-theme = config.gtk.iconTheme.name;
      in
      {
        main = {
          inherit icon-theme;
          font = "${fontName}:size=${toString fontSize}";
          layer = "overlay";
          anchor = "top-left";
          use-bold = true;
          prompt = "\"  \"";
          horizontal-pad = 20;
          inner-pad = 5;
        };
        colors =
          let
            inherit (config.colorscheme) palette;
            inherit (builtins)
              substring
              stringLength
              floor
              ;
            # The function definition
            decimal2Hex =
              d:
              let
                mod = x: y: x - (x / y) * y;
                clampedDecimal =
                  if d < 0 then
                    0
                  else if d > 255 then
                    255
                  else
                    d;
                # Function to convert a single digit to hex
                hexDigits = "0123456789ABCDEF";
                toHex =
                  value:
                  if value < 16 then
                    substring value 1 hexDigits
                  else
                    (toHex (value / 16) + substring (mod value 16) 1 hexDigits);

                # Convert to hex and pad with 0 if necessary
                hexValue = toHex clampedDecimal;
              in
              if stringLength hexValue == 1 then "0${hexValue}" else hexValue;
            addAlphaToHex =
              hex: alpha:
              let
                clampedAlpha =
                  if alpha < 0 then
                    0
                  else if alpha > 1 then
                    1
                  else
                    alpha;
                alphaValue = floor (clampedAlpha * 255);
              in
              "${hex}${decimal2Hex alphaValue}";
          in
          with palette;
          {
            background = addAlphaToHex "${base01}" 0.8;
            text = addAlphaToHex "${base06}" 1.0;
            selection = addAlphaToHex "${base0D}" 1.0;
            selection-text = addAlphaToHex "${base00}" 1.0;
            match = addAlphaToHex "${base0B}" 1.0;
            selection-match = addAlphaToHex "${base0B}" 1.0;
            border = addAlphaToHex "${base04}" 1.0;
          };
      };
  };
}
