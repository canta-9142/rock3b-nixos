{
	description = "NixOS configuration of Radxa ROCK 3B";
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";

		pedantix.url = "github:swarsel/pedantix";
	};
	outputs = input@{ self,
	                  nixpkgs,
	                  nixpkgs-stable,
	                  pedantix,
	                  ... }:
		let
			system = "aarch64-linux";
		in
		{
			nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
				inherit system;
				specialArgs = {
					inherit nixpkgs-stable;
				};

				modules = [
					./configuration.nix

					({ pkgs, ... }: {
						nixpkgs.overlays = [
							(final: prev: {
								pkgsStable = import nixpkgs-stable {
									inherit system;
									config.allowUnfree = true;
								};
							})
						];
					})
				];
			};
		};
}
