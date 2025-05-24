{ host
, ...
}:
{
  programs.fish = {
    enable = true;
    shellInit = ''
      set -g fish_greeting
    '';
    shellAliases = {
      fr = "nh os switch --hostname ${host}";
      fu = "nh os switch --hostname ${host} --update";
      ls = "ls --color=auto";
      ll = "ls -la";
      logout = "hyprctl dispatch exit";
      man-nixos = "man configuration.nix";
      man-hm = "man home-configuration.nix";
      ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
      setup_nix_env = "echo 'use nix' > .envrc && direnv allow";
      arc-login = "ssh -X reub0524@arc-login.arc.ox.ac.uk; or ssh -X reub0524@gateway.arc.ox.ac.uk -- 'ssh -X reub0524@arc-login.arc.ox.ac.uk'";
      arc-htc = "ssh -X reub0524@htc-login.arc.ox.ac.uk; or ssh -X reub0524@gateway.arc.ox.ac.uk -- 'ssh -X reub0524@arc-login.arc.ox.ac.uk'";
    };
  };
}
