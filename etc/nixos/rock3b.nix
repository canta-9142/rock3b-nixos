{ config, lib, pkgs, ... }:

let
	monitorEdid = pkgs.runCommand "monitor-edid" { } ''
		mkdir -p "$out/lib/firmware/edid"
		cp ${./edid/monitor-rk3568.bin} "$out/lib/firmware/edid/monitor-rk3568.bin"
	'';
in
{
	boot.kernelPackages = pkgs.linuxPackages_latest;
	
	services.fstrim.enable = true;
	
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

	systemd.services.rock3b-ethernet-leds = {
		description = "Configure ROCK 3B RTL8211F Ethernet LEDs";
		
		wantedBy = [ "multi-user.target" ];
		wants = [ "network-online.target" ];
		
		after = [ 
			"network-online.target"
			"sys-subsystem-net-devices-end0.device"
			"sys-subsystem-net-devices-end1.device"
		];
		
		serviceConfig = {
			Type = "oneshot";
			RemainAfterExit = true;
		};
		
		script = ''
			set -eu
			
			PHYTOOL="${pkgs.phytool}/bin/phytool"
			SLEEP="${pkgs.coreutils}/bin/sleep"
			
			configure_leds() {
				iface="$1"
				attempt=1

				while [ "$attempt" -le 30 ]; do
					echo "configuring RTL8211F LEDs on $iface ($attempt/30)"

					if "$PHYTOOL" write "$iface/1/31" 0x0d04 &&
					   "$PHYTOOL" write "$iface/1/16" 0x617f &&
					   "$PHYTOOL" write "$iface/1/31" 0x0000; then
						echo "configured RTL8211F LEDs on $iface"
						return 0
					fi

					"$PHYTOOL" write "$iface/1/31" 0x0000 || true
					"$SLEEP" 1
					attempt=$((attempt + 1))
				done

				echo "Failed to configure LEDs on $iface >&2"
				return 1       
			}
			
			configure_leds end0
			configure_leds end1
		'';
	};
}
