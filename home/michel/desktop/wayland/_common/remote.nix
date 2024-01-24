{ pkgs, ... }: # TODO: Create script to help connecting to BNB
{
  home.packages = [ pkgs.openconnect pkgs.remmina ];

  home.persistence."/persist/home/michel" = {
    allowOther = true;
    directories = [ ".local/share/remmina" ".config/remmina" ];
  };
}
