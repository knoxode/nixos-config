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
    hashedPassword = "$6$14MwOQmWC/c0B5Uf$asW2FXs8oG8imtSPs9nLaXnZk1VKduLYz5l6TGBqLS8H64sWmONDOhUlTpHZ8HEl/UsKjD1SoGPyUECAju55z0";
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
  users.users.root = {
    hashedPassword = "$6$re41R8kMD0bE.pPA$msbTYZQbZ0syZcicbHlHrqWXlxGii7IbwOEW1ORNHuEkiIma2pjV4eynsFo46K.MQQ8jg1gth7zgf6JW9bFjB0";
  };
  nix.settings.allowed-users = ["${username}"];
}
