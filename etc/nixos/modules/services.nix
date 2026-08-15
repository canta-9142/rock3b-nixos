{ config, lib, pkgs, ... }:

{
	services.openssh = {
		enable = true;
		openFirewall = false;

		settings = {
			AllowUsers = [ "jinji" ];
			KbdInteractiveAuthentication = false;
			PasswordAuthentication = false;
			PermitRootLogin = "no";
			PubkeyAuthentication = true;
		};
	};
}
