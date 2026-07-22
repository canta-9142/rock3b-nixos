{ config, lib, pkgs, ... }:

{
	networking = {
		hostName = "rock3b-nixos";
		networkmanager.enable = true;
		useDHCP = lib.mkDefault true;
		
		firewall = {
			enable = true;
			allowedTCPPorts = [];
			allowedUDPPorts = [];
		};
	};
}
