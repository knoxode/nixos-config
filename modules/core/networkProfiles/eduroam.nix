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
        # Exactly Oxford's 2026 CAT installer profile: EAP-TTLS with
        # MSCHAPv2 inner auth, Remote Access password (NOT the SSO password).
        # The CAT installer's anonymous outer identity
        # (__ox-2026__0723@OX.AC.UK) is rejected by the live RADIUS (~1s
        # EAP-FAILURE/reason 23 on every BSSID); the real identity works, so
        # don't send one - the supplicant then reuses the inner identity as
        # the outer identity, same as the legacy eduroam profile that works.
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

        # password-flags defaults to 0 (system-owned). The password comes from
        # sops via an env file that the ensure-profiles unit envsubst's into
        # the profile at activation. password-flags=1 (agent-owned) does NOT
        # work here: NM consults user secret agents (nmcli/applets) for the
        # request and activation fails ("Secrets were required, but not
        # provided") even though nm-file-secret-agent serves the file.
        password = "\${EDUROAM_PASSWORD}";
      };

      ipv4.method = "auto";
      ipv6.method = "auto";
    };
  };

  networking.networkmanager.ensureProfiles.environmentFiles = [
    config.sops.templates."eduroam-env".path
  ];
}
