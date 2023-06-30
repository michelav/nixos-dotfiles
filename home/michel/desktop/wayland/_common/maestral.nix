{ pkgs, ... }:
let maestral_cfg = ".config/maestral/maestral.ini";
in {
  home.packages = [ pkgs.maestral pkgs.maestral-gui ];

  /* home.file."${maestral_cfg}".text = ''
       [auth]
       account_id = dbid:AACJ2nkgBKE8yTy9I-l8n-phTgAbCUK-XeQ
       keyring = keyring.backends.SecretService.Keyring

       [app]
       notification_level = 15
       log_level = 20
       update_notification_interval = 604800

       [sync]
       path = /persist/home/michel/Dropbox
       excluded_items = ['/clouddetours', '/descritores', '/unifor', '/sara-15anos', '/uece tcc', '/epson iprint', '/avaliação tcc', '/recibos pacientes', '/trabs_quel', '/epson connect', '/sequentia']
       reindex_interval = 1209600
       max_cpu_percent = 20.0
       keep_history = 604800
       upload = True
       download = True

       [main]
       version = 18.0
     '';
  */

  systemd.user.services.maestral-daemon = {
    Unit = { Description = "Maestral Dropbox Client"; };
    Install = { WantedBy = [ "default.target" ]; };
    Service = {
      Environment = [ "PYTHONOPTIMIZE=2" "LC_CTYPE=UTF-8" ];
      ExecStart = "${pkgs.maestral}/bin/maestral start -f -c maestral";
      ExecReload = "${pkgs.maestral}/bin/maestral stop -c maestral";
      WatchdogSec = "30";
    };
  };
}
