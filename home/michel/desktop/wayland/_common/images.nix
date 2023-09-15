{ config, ... }: {
  programs.imv = let inherit (config.colorscheme) colors;
  in {
    enable = true;
    settings = {
      options = { background = "#${colors.base00}"; };
      aliases = { "<Shift+X>" = ''exec rm "$imv_current_file"; close''; };
    };
  };
}
