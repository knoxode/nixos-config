{
  pkgs,
  inputs,
  username,
  ...
}: 
{
  imports = [inputs.home-manager.nixosModules.home-manager];
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs username;};
    users.${username} = {
      imports = [./../home];
      home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = "23.11";
      };
    };
  };
  users.mutableUsers = false;
  users.users.${username} = {
    isNormalUser = true;
    description = "Main";
    extraGroups = [
      "docker"
      "libvirtd"
      "lp"
      "networkmanager"
      "scanner"
      "wheel"
    ];
    shell = pkgs.bash;
    ignoreShellProgramCheck = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDfRPyTbfUwQ/3V94NfCQ+dNzr9N4MQaRkxsXIqSXp1z powerskater3@gmail.com"
    ];
  };
  nix.settings.allowed-users = ["${username}"];
}
