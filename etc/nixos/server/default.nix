{ ... }:

{
	imports = [
		./forgejo.nix
		./web.nix
		./cloudflared.nix
		./maintenance.nix
	];

	_module.args.homelab = {
		siteDomain = "floating-gate.com";
		gitDomain = "git.floating-gate.com";
		siteRoot = "/srv/www/floating-gate";
	};
}
