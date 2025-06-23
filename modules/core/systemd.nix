{ host, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) hostType;
in
{
  systemd.services.nvidia_oc = if hostType == "Desktop" then {
    description = "NVIDIA Overclocking Service";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "nvidia_oc set --index 0 --power-limit 373000 --freq-offset 160 --mem-offset 1000 --min-clock 0 --max-clock 2000";
      User = "root";
      Restart = "on-failure";
    };
  } else {};
}
