{ config, lib, pkgs, ... }:

{
	users.users = {
		nixos = {
			isNormalUser = true;
		};
		jinji = {
			isNormalUser = true;
			description = "Kanta IMAI";
			extraGroups = [ "wheel" ];
			shell = pkgs.fish;
		};
	};
}
