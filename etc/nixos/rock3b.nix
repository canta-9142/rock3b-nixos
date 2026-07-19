{ config, lib, pkgs, ... }:

let
	monitorEdid = pkgs.runCommand "monitor-edid" { } ''
		mkdir -p "$out/lib/firmware/edid"
		cp ${./edid/monitor-rk3568.bin} "$out/lib/firmware/edid/monitor-rk3568.bin"
	'';
in
{
	boot.initrd.availableKernelModules = [
		"nvme"
	];
	
	hardware.firmware = [
		monitorEdid
	];
	boot.initrd.extraFirmwarePaths = [
		"edid/monitor-rk3568.bin"
	];
	boot.kernelParams = [
		"console=ttyS2,1500000n8"
		"console=tty0"
		"drm.edid_firmware=HDMI-A-1:edid/monitor-rk3568.bin"
	];
	
	hardware.deviceTree = {
		enable = true;
		name = "rockchip/rk3568-rock-3b.dtb";
		overlays = [
			{
				name = "rock3b-fan-always-on";
				dtsText = ''
					/dts-v1/;
					/plugin/;
					/{
						compatible = "radxa,rock-3b";
						fragment@0 {
							target = <&gpio3>;
							__overlay__ {
								fan-always-on-hog {
									gpio-hog;
									gpios = <9 0>;
									output-high;
									line-name = "rock3b-fan-always-on";
								};
							};
						};
					};
				'';
			}
			{
				name = "rock3b-rtl8211f-gmac0";
				dtsText = ''
					/dts-v1/;
					/plugin/;
					/ {
						compatible = "radxa,rock-3b";
						fragment@0 {
							/* gmac0 = fe2a0000 = end0 */
							target-path = "/ethernet@fe2a0000/mdio/ethernet-phy@1";
							__overlay__ {
								compatible = "ethernet-phy-id001c.c916";
								reset-deassert-us = <80000>;
							};
						};
					};
				'';
			}
		];
	};
}
