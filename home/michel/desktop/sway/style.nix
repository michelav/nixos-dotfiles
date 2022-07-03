{ config, ... }:

with config.colorscheme.colors; with config.desktop; ''

  /* Nord */
  @define-color warning #${base0A};
  @define-color critical #${base08};
  @define-color workspacesfocused_bg #${base00};
  @define-color workspacesfocused_fg #${base03};
  @define-color workspace-urgent #${base09};
  @define-color module-bg #${base02};
  @define-color module-bg-alt #${base04};
  @define-color module-fg #${base05};
  @define-color module-fg-alt #${base00};
  @define-color module-fg-anm #${base01};
  @define-color module-bg-gp1 #${base0B};
  @define-color module-bg-gp2 #${base0C};
  @define-color module-bg-gp3 #${base0D};
  @define-color module-bg-gp4 #${base0E};
  @define-color module-bg-gp5 #${base0F};

  * {
    border: none;
    border-radius: 3px;
    min-height: 0;
    margin: 0.2em 0.3em 0.2em 0.3em;
  }

  #waybar {
    background: none;
    color: @module-fg;
    font-family: '${fonts.regular.name}', '${fonts.monospace.name}';
    font-size: 12pt;
    font-weight: normal;

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
      padding-left: 0.8em;
      padding-right: 1.0em;
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
      background: @critical;
      color: @module-fg-anm;
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
      color: @module-fg-anm;
  }
  
  /* Each warning that should blink */
  #battery.warning.discharging {
      animation-name: blink-warning;
      animation-duration: 3s;
  }

  #mode { /* Shown current Sway mode (resize etc.) */
    color: @module-fg;
    background: @module-bg;
  }
  
  /* Workspaces stuff */
  
  #workspaces {
    background: @module-bg;
  }
  
  #workspaces button {
      font-weight: bold; /* Somewhy the bar-wide setting is ignored*/
      padding: 0 0.6em;
      opacity: 0.3;
      background: none;
      font-size: 1em;
  }
  
  #workspaces button.focused {
      background: @workspacesfocused_bg;
      color: @module_fg;
      opacity: 1;
  }
  
  #workspaces button.urgent {
      border-color: @workspace-urgent;
      color: @workspace-urgent;
      opacity: 1;
  }
  
  #window {
      margin-right: 40px;
      margin-left: 40px;
      font-weight: normal;
  }

  #idle_inhibitor {
      background: @module-bg-gp1;
      font-weight: bold;
      padding: 0 0.6em;
      color: @module-fg-alt;
  }

  #bluetooth {
    background: @module-bg;
    font-size: 1.2em;
    font-weight: bold;
    padding: 0 0.6em;
  }

  @keyframes blink-warning {
      70% {
          color: @module-fg-alt;
      }
  
      to {
          color: @module-fg-anm;
          background-color: @warning;
      }
  }
  
  @keyframes blink-critical {
      70% {
        color: @module-fg-alt;
      }
  
      to {
          color: @module-fg-anm;
          background-color: @critical;
      }
  }

  /* Group 0 */
  #custom-media,
  #clock,
  #tray {
    background: none;
    color: @module-fg;
    font-weight: bold;
    font-size: 14pt
  }

  #network {
    background: @module-bg-gp4;
    color: @module-fg-alt;
  }

  /* Group 2 */
  #pulseaudio {
    background: @module-bg-gp3;
    color: @module-fg-alt;
  }

  /* Group 4 */
  #memory,
  #cpu,
  #backlight {
    background: @module-bg-gp2;
    color: @module-fg-alt;
  }

  #battery {
  	background: @module-bg-gp5;
    color: @module-fg-alt;
  }
''
