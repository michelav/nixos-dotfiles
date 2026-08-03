# Google Calendar sync for CalendarPanel.qml: vdirsyncer's `google_calendar`
# storage type is pure OAuth2 (client_id/secret + a refreshable token file),
# so this never touches a Google account password. client_id/client_secret
# are static, low-churn credentials and fit sops; the token file is written
# and refreshed by vdirsyncer at runtime, so it lives on a persisted path
# instead (see the persistence block below), never in a sops secret.
#
# One-time manual bootstrap after deploying this (cannot be made
# declarative): fill in the real credentials with
#   sops home/michel/secrets.yaml
# then run `vdirsyncer discover gcal && vdirsyncer sync` once, interactively,
# to complete the OAuth consent in a browser.
#
# The pair is named "gcal" rather than "google_calendar" because vdirsyncer
# 0.20.0 rejects a pair name that collides with a storage name (confirmed
# empirically: "Section \"storage google_calendar\": Name \"google_calendar\"
# already used"), even though pairs and storages are distinct section types.
{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.userPrefs;
  home = config.home.homeDirectory;
in
{
  config = lib.mkIf (cfg.desktopShell == "quickshell") {
    sops.age.keyFile = "${home}/.config/sops/age/keys.txt";

    sops.secrets."google-calendar-client-id" = {
      sopsFile = ../../../../secrets.yaml;
    };
    sops.secrets."google-calendar-client-secret" = {
      sopsFile = ../../../../secrets.yaml;
    };

    sops.templates."vdirsyncer-config".content = ''
      [general]
      status_path = "~/.local/state/vdirsyncer/status/"

      [pair gcal]
      a = "local_calendar"
      b = "google_calendar"
      collections = ["from b"]

      [storage local_calendar]
      type = "filesystem"
      path = "~/.local/share/calendars/"
      fileext = ".ics"

      [storage google_calendar]
      type = "google_calendar"
      token_file = "~/.local/share/vdirsyncer/google_calendar_token"
      client_id = "${config.sops.placeholder."google-calendar-client-id"}"
      client_secret = "${config.sops.placeholder."google-calendar-client-secret"}"
    '';

    home.packages = [
      pkgs.khal
      pkgs.vdirsyncer
    ];

    home.sessionVariables.VDIRSYNCER_CONFIG = config.sops.templates."vdirsyncer-config".path;

    xdg.configFile."khal/config".text = ''
      [calendars]
      [[google]]
      path = ~/.local/share/calendars/*
      type = discover

      [locale]
      local_timezone = America/Fortaleza
      timeformat = %H:%M
      dateformat = %d/%m/%Y
      longdateformat = %d/%m/%Y
      datetimeformat = %d/%m/%Y %H:%M
      longdatetimeformat = %d/%m/%Y %H:%M
    '';

    systemd.user.services.vdirsyncer-sync = {
      Unit.Description = "Sync Google Calendar via vdirsyncer";
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.vdirsyncer}/bin/vdirsyncer sync";
        Environment = "VDIRSYNCER_CONFIG=${config.sops.templates."vdirsyncer-config".path}";
      };
    };

    systemd.user.timers.vdirsyncer-sync = {
      Unit.Description = "Periodic Google Calendar sync";
      Timer = {
        OnStartupSec = "2m";
        OnUnitActiveSec = "15m";
      };
      Install.WantedBy = [ "timers.target" ];
    };

    # No other module owns this: khal/vdirsyncer's synced vdir and the OAuth
    # token vdirsyncer writes/refreshes at runtime.
    home.persistence."/persist".directories = [
      ".local/share/calendars"
      ".local/share/vdirsyncer"
      ".local/state/vdirsyncer"
    ];
  };
}
