{config, ...}: let
  eduroamCert = config.sops.secrets."eduroam/cert".path;
  eduroamPassword = config.sops.secrets."eduroam/password".path;
in {
  networking.networkmanager.ensureProfiles = {
    profiles.eduroam = {
      connection = {
        id = "Eduroam";
        type = "wifi";
        autoconnect = true;
      };

      wifi = {
        ssid = "eduroam";
        mode = "infrastructure";
      };

      wifi-security.key-mgmt = "wpa-eap";

      "802-1x" = {
        eap = "ttls";
        identity = "REUB0524@OX.AC.UK";
        anonymous-identity = "__ox-2026__0723@OX.AC.UK";
        phase2-auth = "mschapv2";

        ca-cert = eduroamCert;
        domain-match = "radius.ox.ac.uk";

        password-flags = 1;
      };

      ipv4.method = "auto";
      ipv6.method = "auto";
    };
    secrets.entries = [
      {
        matchId = "Eduroam";
        #matchType = "wifi";
        matchSetting = "802-1x";
        key = "password";
        file = eduroamPassword;
      }
    ];
  };
}
