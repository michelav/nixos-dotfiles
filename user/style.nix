{ config, ... }:

with config.colorscheme.colors; ''
  * {
    border: none;
    border-radius: 0;
    font-family: '${config.gtk.font.name}', monospace, 'JetBrainsMonoMedium Nerd Font';
    font-size: 16px;
    min-height: 0;
    margin: 0;
    padding: 0;
  }

  /* waybar */
  window#waybar {
    background: none;
    color: #${base06};
  }

  /* modules defaults */
  #workspaces,
  #custom-pkgs,
  #custom-bluetooth,
  #network,
  #idle_inhibitor,
  #pulseaudio,
  #backlight,
  #battery,
  #language,
  #clock,
  #custom-scratchpad,
  #mode,
  #tray,
  #mpd {
    background: #${base00};
    padding: 0.25rem 0.75rem;
    margin: 0 0.65rem;
    color: #${base06};
    border-radius: 0.15rem;
  }

  .modules-left {
    margin-left: 1.5rem;
  }
  .modules-right {
    margin-right: 1.5rem;
  }

  /* workspaces */
  #workspaces {
    font-weight: bold;
  }

  #workspaces button {
    background: none;
  }

  #workspaces button.focused {
    color: #${base0D};
  }

  #workspaces button.urgent {
    color: #${base08};
  }

  #workspaces button:hover {
    color: #${base0B};
  }

  /* scratchpad */
  #custom-scratchpad {
    background: #${base0D};
    color: #${base00};
  }

  /* mpd */
  #mpd.disconnected {
    opacity: 0;
  }

  /* tray */
  #tray {
    margin-left: 1rem;
    margin-right: 1rem;
  }
''
