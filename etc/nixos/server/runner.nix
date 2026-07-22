{ homelab, pkgs, ... }:

{
	virtualisation.podman.enable = true;

	services.gitea-actions-runner = {
		package = pkgs.forgejo-runner;

		instances.floatinggate = {
			enable = true;

			name = "rock3b-floating-gate";
			url = "http://127.0.0.1:3000";
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
