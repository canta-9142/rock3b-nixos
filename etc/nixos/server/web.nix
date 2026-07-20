{ homelab, pkgs, ... }:

let
	bootstrapSite = pkgs.writeTextDir "index.html" ''
		<!doctype html>
		<html lang="ja">
			<head>
				<meta charset="utf-8">
				<meta name="viewport" content="width=device-width, initial-scale=1">
				<title>Floating-Gate.com</title>
			</head>
			<body>
				<h1>Floating-gate.com</h1>
				<p>Deployment pipeline in being prepared.</p>
			</body>
		</html>
	'';
in
{
	users.groups.site-deploy = {};
	users.users.site-deploy = {
		isSystemUser = true;
		group = "site-deploy";
		home = homelab.siteRoot;
		createHome = false;
	};

	systemd.tmpfiles.rules = [
		"d ${homelab.siteRoot} 0755 site-deploy site-deploy -"
		"d ${homelab.siteRoot}/releases 0755 site-deploy site-deploy -"
		"L ${homelab.siteRoot}/current - - - - ${bootstrapSite}"
	];

	services.nginx = {
		enable = true;

		recommendedOptimisation = true;
		recommendedProxySettings = true;
		recommendedTlsSettings = true;

		appendHttpConfig = ''
			proxy_headers_hash_max_size 1024;
			proxy_headers_hash_bucket_size 128;
		'';

		virtualHosts = {
			"${homelab.siteDomain}" = {
				listen = [
					{
						addr = "127.0.0.1";
						port = 8080;
					}
				];

				root = "${homelab.siteRoot}/current";
			};

			"${homelab.gitDomain}" = {
				listen = [
					{
						addr = "127.0.0.1";
						port = 8081;
					}
				];

				extraConfig = ''
					client_max_body_size 512M;
				'';

				locations."/" = {
					proxyPass = "http://127.0.0.1:3000";
					proxyWebsockets = true;

					extraConfig = ''
						proxy_set_header X-Forwarded-Proto https;
					'';
				};
			};
		};
	};
}
