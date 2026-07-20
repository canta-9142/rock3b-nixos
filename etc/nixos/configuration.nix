# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./rock3b.nix
      
      ./modules/boot.nix
      ./modules/networking.nix
      ./modules/services.nix
      ./modules/packages.nix
      ./modules/users.nix
      
      ./desktop/plasma.nix

      ./server
    ];

  nix.settings.experimental-features = [
  	"nix-command"
  	"flakes"
  ];

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  system.stateVersion = "26.05";

}

