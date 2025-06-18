{...}:
{
services.tlp = {
  enable = true;
  settings = {

    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
#
    CPU_ENERGY_PERF_POLICY_ON_BAT = "balance-power";
    CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
#
    CPU_MIN_PERF_ON_AC = 0;
    CPU_MAX_PERF_ON_AC = 100;
#
    START_CHARGE_THRESH_BAT0 = 50; # Charges when below 75
    STOP_CHARGE_THRESH_BAT0 = 80; # Stops charging at 80

    #Regulates the state of Intel Dynamic Boosting - 1 is allowed, 0 is disallowed.
    CPU_HWP_DYN_BOOST_ON_AC=1;
    CPU_HWP_DYN_BOOST_ON_BAT=0;
   };
  };
}

