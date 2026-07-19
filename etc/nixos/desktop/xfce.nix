{ config, lib, pkgs, ... }:

{
	services.xserver = {
		enable = true;
		displayManager.lightdm.enable = true;
		desktopManager.xfce.enable = true;

		deviceSection = ''
		  Option "SWcursor" "true"
		  Option "PageFlip" "false"
		'';
	};
}
