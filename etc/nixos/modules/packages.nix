{ config, lib, pkgs, ... }:

{
	environment.systemPackages = with pkgs; [
		micro
		vim
		fish
		git
		gh
		wget
		curl
		fastfetch
		fetch
		tree
		yazi
		btop
		htop
		zellij

		alacritty
	];

	programs.fish.enable = true;
	programs.firefox.enable = true;
}
