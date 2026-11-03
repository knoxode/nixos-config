{config, ...}: {
  networking.networkmanager.ensureProfiles = {
    profiles.eduroam = {
      connection = {
        id = "eduroam";
        type = "wifi";
        autoconnect = true;
        # Beat any persisted legacy profile on this SSID (eduroam-old) in
        # autoconnect arbitration: NM's most-recently-used default also keeps
        # choosing the old profile whenever this profile's activation stalls.
        autoconnect-priority = 10;
      };

      wifi = {
        ssid = "eduroam";
        mode = "infrastructure";
      };

      wifi-security.key-mgmt = "wpa-eap";

      "802-1x" = {
        # Oxford's 2025-era CAT installer settings: EAP-TTLS with MSCHAPv2
        # inner auth, Remote Access password (NOT the SSO password).
        # The anonymous outer identity is CA-year specific: the 2026 tag
        # (__ox-2026__0723@OX.AC.UK) is rejected outright by the RADIUS
        # that serves the 2025 root (~1s EAP-FAILURE/reason 23), so this is
        # the 2025 tag. Plain identity alone also authenticates, and
        # Oxford may rotate to the 2026 cert exclusively later; swap the
        # tag then (or drop it as a stopgap).
        anonymous-identity = "__ox-2025__0613@OX.AC.UK";
        eap = "ttls";
        identity = "reub0524@ox.ac.uk";
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

        # password-flags=1: agent-owned - nm-file-secret-agent serves the
        # sops secret file on D-Bus when NM asks for the password, so the
        # keyfile itself holds no plaintext.
        password-flags = 1;
      };

      ipv4.method = "auto";
      ipv6.method = "auto";
    };

    secrets.entries = [
      {
        matchId = "eduroam";
        matchSetting = "802-1x";
        key = "password";
        file = config.sops.secrets."eduroam/password".path;
      }
    ];
  };
}
