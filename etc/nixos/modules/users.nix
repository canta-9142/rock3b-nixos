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

	security.sudo.extraRules = [
		{
			users = [ "jinji" ];
			commands = [
				{
					command = "/run/current-system/sw/bin/git";
					options = [ "NOPASSWD" ];
				}
				{
					command = "/run/current-system/sw/bin/gh";
					options = [ "NOPASSWD" ];
				}
			];
		}
	];
}
