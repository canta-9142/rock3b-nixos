{ ... }:

let
	tunnelId = "1580b2a0-ac81-404d-a5cd-34231f5b50e2";
	credentialsSource = "/home/jinji/.cloudflared/${tunnelId}.json";
	credentialsFile = "/var/lib/cloudflared/${tunnelId}.json";
in
{
	services.cloudflared = {
		enable = true;

		tunnels.${tunnelId} = {
			inherit credentialsFile;

			ingress = {
				"floating-gate.com"     = "http://127.0.0.1:8080";
				"git.floating-gate.com" = "http://127.0.0.1:8081";
			};

			default = "http_status:404";
		};
	};

	systemd.tmpfiles.rules = [
		"d /var/lib/cloudflared 0750 cloudflared cloudflared -"
		"C ${credentialsFile} 0400 cloudflared cloudflared - ${credentialsSource}"
	];

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
