{
  host,
  config,
  lib,
  pkgs,
  inputs,
  username,
  profile,
  ...
}: let
in {
  imports = [inputs.home-manager.nixosModules.home-manager];
  home-manager = {
    sharedModules = [./../home];
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs username profile host;};
    users.shaiikura = {
      home = {
        username = "shaiikura";
        homeDirectory = "/home/shaiikura";
        stateVersion = "23.11";
      };
      imports = [./../home/users/shaiikura];
    };
    users.kuchikopi = {
      home = {
        username = "kuchikopi";
        homeDirectory = "/home/kuchikopi";
        stateVersion = "23.11";
      };
      imports = [./../home/users/kuchikopi];
    };
  };

  users = {
    mutableUsers = false;
    users = {
      shaiikura = {
        hashedPassword = "$6$14MwOQmWC/c0B5Uf$asW2FXs8oG8imtSPs9nLaXnZk1VKduLYz5l6TGBqLS8H64sWmONDOhUlTpHZ8HEl/UsKjD1SoGPyUECAju55z0";
        isNormalUser = true;
        description = "Alex";
        extraGroups = [
          "docker"
          "gamemode"
          "i2c"
          "video"
          "libvirtd"
          "lp"
          "networkmanager"
          "scanner"
          "wheel"
        ];
        shell = pkgs.zsh;
        ignoreShellProgramCheck = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILvGiyiyLH76R6eCLm+9+aRJOrhhpog2d5JncPtcd/1v powerskater3@gmail.com"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBZ3gqvZ1XNqBKICDp4q3ILJjDbYqEbYteEHK+9wB1FW powerskater3@gmail.com"
        ];
      };
      kuchikopi = {
        hashedPassword = "$6$VmLAW3ghkUab0nTH$PTKoixhdumNZV6zdZ0T8A7iwpfpanzwdF4fs2Ey08VPtViL/91hlfIIz2c7REKS9Zu09J6r7S1Wgqi8izDfcz.";
        isNormalUser = true;
        description = "Hajrah";
        extraGroups = [
          "docker"
          "gamemode"
          "i2c"
          "video"
          "libvirtd"
          "lp"
          "networkmanager"
          "scanner"
          "wheel"
        ];
        shell = pkgs.zsh;
        ignoreShellProgramCheck = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILvGiyiyLH76R6eCLm+9+aRJOrhhpog2d5JncPtcd/1v powerskater3@gmail.com"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBZ3gqvZ1XNqBKICDp4q3ILJjDbYqEbYteEHK+9wB1FW powerskater3@gmail.com"
        ];
      };
      root = {
        hashedPassword = "$6$re41R8kMD0bE.pPA$msbTYZQbZ0syZcicbHlHrqWXlxGii7IbwOEW1ORNHuEkiIma2pjV4eynsFo46K.MQQ8jg1gth7zgf6JW9bFjB0";
        description = lib.mkForce "Root";
      };
    };
  };
  nix.settings.allowed-users = ["shaiikura" "kuchikopi"];
}
