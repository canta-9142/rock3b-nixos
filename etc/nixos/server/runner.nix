{ pkgs, ... }:

{
	virtualisation.podman.enable = true;

	services.gitea-actions-runner = {
		package = pkgs.forgejo-runner;

		instances.floating-gate = {
			enable = true;

			name = "rock3b-floating-gate";
			url = "https://git.floating-gate.com";
			tokenFile = "/etc/forgejo-runner/token.env";

			labels = [
				"node-22:docker://docker.io/library/node:22-bookworm"
			];

			settings.runner = {
				capacity = 1;
				timeout = "1h";
			};
		};
	};
}
