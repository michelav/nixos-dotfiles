{ config, pkgs, ... }: {
  home.packages = [ pkgs.dunst ];
  services.dunst = {
    enable = true;
    iconTheme = with config.gtk.iconTheme; { inherit name package; };
    settings = with config.colorScheme.palette; {
      global = with config.desktop; {
        font = "${fonts.regular.name} 8";
        markup = true;
        format = "<b>%s</b>\\n%b";
        indicate_hidden = true;
        alignment = "left";
        show_age_threshold = 60;
        word_wrap = true;
        ignore_newline = false;
        width = 250;
        height = 200;
        origin = "top-right";
        notification_limit = 5;
        idle_threshold = 120;
        follow = "keyboard";
        sticky_history = true;
        line_height = 0;
        padding = 8;
        horizontal_padding = 8;
        separator_color = "#${base03}";
        frame_width = 1;
        frame_color = "#${base01}";
        show_indicators = false;
        icon_position = "left";
        min_icon_size = 16;
        max_icon_size = 32;
      };
      urgency_low = {
        timeout = 5;
        frame_color = "#${base01}";
        background = "#${base02}";
        foreground = "#${base05}";
      };
      urgency_normal = {
        timeout = 10;
        frame_color = "#${base08}";
        background = "#${base02}";
        foreground = "#${base08}";
      };
      urgency_high = {
        timeout = 20;
        frame_color = "#${base0A}";
        background = "#${base02}";
        foreground = "#${base0A}";
      };
    };
  };
}
