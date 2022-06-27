{ colors, ... }:

with colors; {
  focused = {
    border = "#${base0D}";
    background = "#${base0D}";
    text = "#${base00}";
    indicator = "#${base0F}";
    childBorder = "";
  };
  focusedInactive = {
    border = "#${base00}";
    background = "#${base00}";
    text = "#${base06}";
    indicator = "#${base0F}";
    childBorder = "";
  };
  unfocused = {
    border = "#${base00}";
    background = "#${base00}";
    text = "#${base06}";
    indicator = "#${base0F}";
    childBorder = "";
  };
  urgent = {
    border = "#${base08}";
    background = "#${base08}";
    text = "#${base00}";
    indicator = "#${base0F}";
    childBorder = "";
  };
}


