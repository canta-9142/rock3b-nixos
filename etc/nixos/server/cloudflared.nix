{ homelab, pkgs, ... }:

let
	tunnelId = "1580b2a0-ac81-404d-a5cd-34231f5b50e2";
	credentialsFile = "/var/lib/cloudflared/${tunnelId}.json";
in
{
	environment.systemPackages = [
		pkgs.cloudflared
	];
	
	services.cloudflared = {
		enable = true;

		tunnels.${tunnelId} = {
			inherit credentialsFile;

			ingress = {
				           "floating-gate.com" = "http://127.0.0.1:8080";
				       "ssh.floating-gate.com" =  "ssh://127.0.0.1:2222";
				   "forgejo.floating-gate.com" = "http://127.0.0.1:8081";
				"forgejossh.floating-gate.com" =  "ssh://127.0.0.1:2223";
			};

			default = "http_status:404";
		};
	};

	systemd.services."cloudflared-tunnel-${tunnelId}" = {
		after = [
			"network-online.target"
			"nginx.service"
			"forgejo.service"
		];

		wants = [
			"network-online.target"
		];
	};
}
