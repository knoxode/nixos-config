{config, ...}: {
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
        # Exactly Oxford's 2026 CAT installer profile: EAP-TTLS with
        # MSCHAPv2 inner auth, anonymous outer identity, Remote Access
        # password (NOT the SSO password).
        eap = "ttls";
        identity = "REUB0524@OX.AC.UK";
        anonymous-identity = "__ox-2026__0723@OX.AC.UK";
        phase2-auth = "mschapv2";

        # The Oxford eduroam CA is public (distributed via cat.eduroam.org);
        # keep it in the repo rather than sops - wpa_supplicant runs in a
        # systemd chroot that binds /nix/store read-only but cannot see
        # /run/secrets.d, so a sops-backed path never loads ("EAP-TTLS:
        # Failed to initialize SSL").
        ca-cert = "${./eduroam-ca.pem}";
        # NM keyfile property is plural ("altsubject-matches"); a single
        # element is fine as a plain string.
        altsubject-matches = "DNS:radius.ox.ac.uk";

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
        file = config.sops.secrets."eduroam/password".path;
      }
    ];
  };
}
