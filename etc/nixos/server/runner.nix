{
  homelab,
  lib,
  pkgs,
  ...
}:

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

      settings.container = {
        privileged = false;
        options = "--volume ${homelab.siteRoot}:${homelab.siteRoot}:rw";
        valid_volumes = [ homelab.siteRoot ];
        docker_host = "-";
      };
    };
  };

  systemd.services.gitea-runner-floatinggate.serviceConfig.SupplementaryGroups = lib.mkAfter [
    "site-deploy"
  ];
}
