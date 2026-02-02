{host, ...}: let
  cpuEnergyPerfonBat =
    if host == "nomad"
    then "balance_power"
    else "power";
  platProfOnBat =
    if host == "nomad"
    then "balanced"
    else "low-power";
in {
  services.tlp = {
    enable = true;
    settings = {
      # CPU_SCALING_GOVERNOR_ON_AC = "performance";
      # CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      RUNTIME_PROFILE_ON_BAT = "auto";
      RUNTIME_PROFILE_ON_AC = "auto";
      #
      CPU_ENERGY_PERF_POLICY_ON_BAT = cpuEnergyPerfonBat;
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_power";

      PLATFORM_PROFILE_ON_BAT = platProfOnBat;
      PLATFORM_PROFILE_ON_AC = "balanced";

      WIFI_PWR_ON_AC = "on";
      WIFI_PWR_ON_BAT = "on";
      #
      # CPU_MIN_PERF_ON_AC = 0;
      # CPU_MAX_PERF_ON_AC = 100;
      #
      START_CHARGE_THRESH_BAT0 = 70; # Charges when below 75
      STOP_CHARGE_THRESH_BAT0 = 80; # Stops charging at 80

      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      #Regulates the state of Intel Dynamic Boosting - 1 is allowed, 0 is disallowed.
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;
    };
  };
}
