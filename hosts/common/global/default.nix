{
  # TODO: Create a function to load all files from dir excluding default.nix
  imports = [ ./nix.nix ./sops.nix ./virtualisation.nix ];
}
