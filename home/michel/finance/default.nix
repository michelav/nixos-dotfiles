{ pkgs, config, ... }: {
  home.packages = with pkgs; [
    # TODO: Adjust to default version as soon as nixpkgs gets the latest version
    hledger_131
    hledger-ui_131
    hledger-web_131
    hledger-check-fancyassertions
    ledger
    gnucash
  ];

  home.sessionVariables = {
    LEDGER_FILE = "${config.home.homeDirectory}/repos/financas/current.journal";
  };
}
