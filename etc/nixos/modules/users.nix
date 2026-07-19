{ config, lib, pkgs, ... }:

{
	users.users = {
		root = {
			shell = pkgs.fish;
		};
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
