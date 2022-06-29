{ config, ... }:

with config.colorscheme.colors; with config.desktop; ''

  /* Nord */
  @define-color bg #${base00};
  @define-color light #${base05};
  @define-color warning #${base0A};
  @define-color critical #${base08};
  @define-color mode #${base02};
  @define-color workspacesfocused #${base03};
  @define-color tray @workspacesfocused;
  @define-color module-bg #${base02};
  @define-color module-fg #${base05};
  @define-color module-inv-fg #${base04};
  @define-color module-inv-bg #${base05};

  * {
    border: none;
    border-radius: 3px;
    min-height: 0;
    margin: 0.2em 0.3em 0.2em 0.3em;
  }

  #waybar {
    background: @bg;
    color: @light;
    font-family: '${fonts.regular.name}', '${fonts.monospace.name}';
    font-size: 12pt;
    font-weight: bold;

  }
  
  /* Each module */
  #battery,
  #clock,
  #cpu,
  #custom-layout,
  #memory,
  #mode,
  #custom-media,
  #network,
  #pulseaudio,
  #temperature,
  #idle_inhibitor,
  #window,
  #tray,
  #backlight {
      padding-left: 0.6em;
      padding-right: 0.6em;
  }

  /* Each module that should blink */
  #mode,
  #memory,
  #temperature,
  #battery {
      animation-timing-function: linear;
      animation-iteration-count: infinite;
      animation-direction: alternate;
  }

  /* Each critical module */
  #memory.critical,
  #cpu.critical,
  #temperature.critical,
  #battery.critical {
      color: @critical;
  }
  
  /* Each critical that should blink */
  #mode,
  #memory.critical,
  #temperature.critical,
  #battery.critical.discharging {
      animation-name: blink-critical;
      animation-duration: 2s;
  }
  
  /* Each warning */
  #network.disconnected,
  #memory.warning,
  #cpu.warning,
  #temperature.warning,
  #battery.warning {
      background: @warning;
      color: @module-inv-fg;
  }
  
  /* Each warning that should blink */
  #battery.warning.discharging {
      animation-name: blink-warning;
      animation-duration: 3s;
  }

  #mode { /* Shown current Sway mode (resize etc.) */
    color: @light;
    background: @mode;
  }
  
  /* Workspaces stuff */
  
  #workspaces {
  }
  
  #workspaces button {
      font-weight: bold; /* Somewhy the bar-wide setting is ignored*/
      padding: 0;
      opacity: 0.3;
      background: none;
      font-size: 1em;
  }
  
  #workspaces button.focused {
      background: @workspacesfocused;
      color: @module-fg;
      opacity: 1;
      padding: 0 0.4em;
  }
  
  #workspaces button.urgent {
      border-color: #c9545d;
      color: #c9545d;
      opacity: 1;
  }
  
  #window {
      margin-right: 40px;
      margin-left: 40px;
      font-weight: normal;
  }

  #idle_inhibitor {
      background: @mode;
      font-weight: bold;
      padding: 0 0.6em;
      color: @light;
  }

  #bluetooth {
    background: @module-bg;
    font-size: 1.2em;
    font-weight: bold;
    padding: 0 0.6em;
  }

  @keyframes blink-warning {
      70% {
          color: @light;
      }
  
      to {
          color: @light;
          background-color: @warning;
      }
  }
  
  @keyframes blink-critical {
      70% {
        color: @light;
      }
  
      to {
          color: @light;
          background-color: @critical;
      }
  }
  #memory,
  #clock,
  #battery,
  #pulseaudio,
  #network,
  #cpu,
  #custom-media,
  #backlight {
    background: @module-bg;
    color: @light;
  }

  #tray {
  	background: @tray;
    color: @light;
  }
''
