{ pkgs, ... }: {
  programs.password-store = {
    enable = true;
    package = with pkgs; pass-wayland.withExtensions (exts: [ exts.pass-otp ]);
    settings = { PASSWORD_STORE_DIR = "$HOME/.secrets/password-store"; };
  };
}
