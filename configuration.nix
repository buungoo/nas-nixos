{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./storage.nix
      ./fans.nix
    ];

  boot.loader = {
	efi.canTouchEfiVariables = true;

        # Set how long we wait at build screen
        timeout = 1;

        systemd-boot.enable = true;

        # Sets the resolution of the boot screen
        systemd-boot.consoleMode = "max";

        # Disable the bootloader editor for security
        systemd-boot.editor = false;
  };

  time.timeZone = "Europe/Stockholm";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "sv_SE.UTF-8";
      LC_IDENTIFICATION = "sv_SE.UTF-8";
      LC_MEASUREMENT = "sv_SE.UTF-8";
      LC_MONETARY = "sv_SE.UTF-8";
      LC_NAME = "sv_SE.UTF-8";
      LC_NUMERIC = "sv_SE.UTF-8";
      LC_PAPER = "sv_SE.UTF-8";
      LC_TELEPHONE = "sv_SE.UTF-8";
      LC_TIME = "sv_SE.UTF-8";
    };
  };
  console.keyMap = "sv-latin1";
  services.xserver.xkb = {
    layout = "se";
    variant = "nodeadkeys";
  };

  networking = {
    hostName = "nas0";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 49852 ];
      allowedUDPPorts = [ 49852 ];
    };
  };

  services.fail2ban = {
    enable = true;
    maxretry = 3;
    bantime = "3600";
    jails = {
      sshd = {
        settings = {
          enable = true;
          port = "22";
          filter = "sshd";
          logpath = "/var/log/auth.log";
        };
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bungo = {
    isNormalUser = true;
    description = "bungo";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
    ];
    shell = pkgs.zsh;
  };

  # Specify services that may be on the system
  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false; # Disable password authentication
        PermitRootLogin = "prohibit-password"; # Only allow root login with SSH keys
        KbdInteractiveAuthentication = false; # Disable interactive authentication
      };
    };
  };

  # Specify program that may be on the system
  programs = {
    zsh.enable = true;
    firefox.enable = true;
  };

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    neovim
    lazydocker
    mergerfs
  ];

  # Enable virtualisation through docker
  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
      daemon.settings = {
        hosts = [
	  "unix:///var/run/docker.sock"  # Keep the Unix socket for local access
	  # "tcp://0.0.0.0:2375"           # Listen on all interfaces on port 2375
        ];
      };
    };
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "24.11"; # Read docs before considering updating
}
