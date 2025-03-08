{ config, pkgs, ... }:

{
	services.nginx = {
		enable = true;
		# Open firewall ports for HTTP/HTTPS
		recommendedProxySettings = true;
		virtualHosts = {
			# "bungos.xyz" = {
			# 	# Proxy all requests to a Docker container running on port 8080
			# 	locations."/" = {
			# 		proxyPass = "http://192.168.1.134:8080"; # Replace 8080 with your container's port
			# 			proxyWebsockets = true; # Enable WebSocket support
			# 	};
			# 	# Enable SSL via Let's Encrypt (optional but recommended)
			# 	forceSSL = true;
			# 	enableACME = true;
			# };
			# Add more domains/subdomains as needed
			# "homeassistant.bungos.xyz" = {
			# 	locations."/" = {
			# 		proxyPass = "http://192.168.1.10:8123"; # Another Docker container
			# 			proxyWebsockets = true;
			# 	};
			# 	forceSSL = true;
			# 	enableACME = true;
			# };
			"qbit.bungos.xyz" = {
				locations."/" = {
					proxyPass = "http://192.168.1.134:8081"; # Another Docker container
						proxyWebsockets = true;
				};
				forceSSL = true;
				enableACME = true;
			};
		};
	};

	# Allow HTTP/HTTPS traffic through the firewall
	networking.firewall.allowedTCPPorts = [ 80 443 ];

	# Automatically generate SSL certificates with Let's Encrypt
	security.acme = {
		acceptTerms = true;
		defaults.email = "bergdahlalex@protonmail.com";
	};
}
