{ config, ... }: {
  programs.imv = let inherit (config.colorscheme) palette;
  in {
    enable = true;
    settings = {
      options = { background = "#${palette.base00}"; };
      aliases = { "<Shift+X>" = ''exec rm "$imv_current_file"; close''; };
    };
  };
}
