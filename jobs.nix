{ config, pkgs, ... }:
{
	systemd.services.update-port = {
		serviceConfig = {
			Type = "oneshot";
			User = "bungo";
			ExecStart = "/opt/docker/yams/scripts/update-port.sh";
		};
	};
}
