{ lib, ... }:
{
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    openFirewall = true;

    # The nixpkgs ipp-usb module (enabled by printing) sets the obsolete
    # `services.avahi.publish.*` options, which trigger evaluation warnings.
    # Null them out and mirror the same effective values with the new-style
    # settings so behavior is unchanged without the warnings.
    publish = {
      enable = lib.mkForce null;
      userServices = lib.mkForce null;
    };
    settings.publish = {
      "disable-publishing" = false;
      "disable-user-service-publishing" = false;
      "publish-addresses" = true;
    };
  };
}
