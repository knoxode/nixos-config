{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.groups = {
  };
  users.users.shaiikura = {
    isNormalUser = true;
    description = "Alex Ryder";
    extraGroups = [ "networkmanager" "wheel" "openrazer" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDfRPyTbfUwQ/3V94NfCQ+dNzr9N4MQaRkxsXIqSXp1z powerskater3@gmail.com"
    ];
    packages = with pkgs; [
      starship
    ];
  };
}
