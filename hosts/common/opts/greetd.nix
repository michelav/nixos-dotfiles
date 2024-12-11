{ pkgs, ... }:
let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  cmd = "uwsm start hyprland-uwsm.desktop";
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${tuigreet} --greeting 'Welcome to Vega!' --asterisks --remember --remember-user-session --time --cmd '${cmd}'";
        user = "greeter";
      };
      initial_session = {
        command = "${cmd}";
        user = "michel";
      };
    };
  };
}
