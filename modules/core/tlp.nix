{
  host,
  lib,
  ...
}: let
  isDesktop = host == "node";
  isLaptop = host != "node";

  cpuEnergyPerfonBat =
    if isLaptop
    then "balance_power"
    else "power";

  platProfOnBat =
    if isLaptop
    then "balanced"
    else "low-power";
in {
  services.tlp = {
    enable = !isDesktop;

    settings = lib.mkIf (!isDesktop) {
      RUNTIME_PROFILE_ON_BAT = "auto";
      RUNTIME_PROFILE_ON_AC = "auto";

      CPU_ENERGY_PERF_POLICY_ON_BAT = cpuEnergyPerfonBat;
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_power";

      PLATFORM_PROFILE_ON_BAT = platProfOnBat;
      PLATFORM_PROFILE_ON_AC = "balanced";

      WIFI_PWR_ON_AC = "on";
      WIFI_PWR_ON_BAT = "on";

      START_CHARGE_THRESH_BAT0 = 70;
      STOP_CHARGE_THRESH_BAT0 = 80;

      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;
    };
  };

  # Only force governor on desktop
  powerManagement.cpuFreqGovernor =
    lib.mkIf isDesktop "schedutil";
}
