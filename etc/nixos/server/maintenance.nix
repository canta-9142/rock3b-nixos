{ ... }:

{
	nix.gc = {
		automatic = true;
		dates = "Sun 04:00";
		options = "--delete-older-than 14d";
	};

	services.journald.extraConfig = ''
		SystemMaxUse=512M
		RuntimeMaxUse=128M
		MaxRetensionSec=14day
	'';
}
