{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/rock3b.nix

    ../../modules/nixos/boot.nix
    ../../modules/nixos/networking.nix
    ../../modules/nixos/services.nix
    ../../modules/nixos/packages.nix
    ../../modules/nixos/users.nix

    ../../modules/nixos/server
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  networking.hostName = "rock3b-nixos";

  systemd.tmpfiles.rules = [
    "L+ /etc/nixos - jinji users - /home/jinji/rock3b-nixos"
  ];

  system.stateVersion = "26.05";

}
