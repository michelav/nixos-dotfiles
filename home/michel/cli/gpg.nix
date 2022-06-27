{ pkgs, desktop, lib, ... }: {
  home.packages =
    if desktop != null
    then [ pkgs.pinentry-gnome ]
    else [ pkgs.pinentry-curses ];

  services.gpg-agent = {
    enable = true;
    enableFishIntegration = true;
    # enableSshSupport = true;
    pinentryFlavor = if desktop != null then "gnome3" else "curses";
  };

  programs.gpg = {
    enable = true;
  };

}
