{ homelab, pkgs, ... }:

{
	services.forgejo = {
		enable = true;
		package = pkgs.forgejo;

		database.type = "sqlite3";
		lfs.enable = true;

		settings = {
			server = {
				DOMAIN = homelab.gitDomain;
				ROOT_URL = "https://${homelab.gitDomain}";

				PROTOCOL = "http";
				HTTP_ADDR = "127.0.0.1";
				HTTP_PORT = 3000;

				DISABLE_SSH = false;
				START_SSH_SERVER = true;

				BUILTIN_SSH_SERVER_USER = "git";
				SSH_DOMAIN = homelab.gitsshDomain;

				SSH_PORT = 22;

				SSH_LISTEN_HOST = "127.0.0.1";
				SSH_LISTEN_PORT = 2223;
			};

			service = {
				DISABLE_REGISTRATION = true;
				SHOW_REGISTRATION_BUTTON = false;
			};

			actions.ENABLED = true;

			log.LEVEL = "Info";
		};

		dump = {
			enable = true;
			interval = "03:30";
			backupDir = "/var/backup/forgejo";
			type = "tar.zst";
		};
	};

	environment.systemPackages = [
		pkgs.forgejo
	];

	systemd.tmpfiles.rules = [
		"d /var/backup/forgejo 0700 forgejo forgejo 30d"
	];
}
