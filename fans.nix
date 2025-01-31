{ config, pkgs, ... }:

{
  imports =[ ./hardware-configuration.nix ];

  environment.systemPackages = with pkgs; [ lm_sensors ];

  boot.extraModulePackages = with pkgs.linuxPackages; [ it87 ];
  boot.kernelModules = [ "coretemp" "it87" ];

  hardware.fancontrol = {
    enable = true;
    config = ''
      INTERVAL=5
      DEVPATH=hwmon2=devices/platform/coretemp.0 hwmon3=devices/platform/it87.2608
      DEVNAME=hwmon2=coretemp hwmon3=it8613
      FCTEMPS=hwmon3/pwm2=hwmon2/temp1_input
      FCFANS=hwmon3/pwm2=hwmon3/fan2_input
      MINTEMP=hwmon3/pwm2=35
      MAXTEMP=hwmon3/pwm2=85
      MINSTART=hwmon3/pwm2=16
      MINSTOP=hwmon3/pwm2=16
      MINPWM=hwmon3/pwm2=0
      MAXPWM=hwmon3/pwm2=255
    '';
  };
}
