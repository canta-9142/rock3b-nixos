{ ... }:

{
	imports = [
		./forgeji.nix
		./web.nix
		./maintenance.nix
	];

	_modules.args.homelab = {
		siteDomain = "floating-gate.com";
		gitDomain = "git.floating-gate.com";
		siteRoot = "/srv/www/floating-gate";
	};
}
