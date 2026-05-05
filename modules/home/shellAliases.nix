{
  host,
  lib,
  ...
}: let
  shellAliases = {
    c = "clear";
    fr = "nh os switch --hostname ${host}";
    fraow = "nh os switch --hostname ${host} -- --option abort-on-warn true --show-trace";
    fu = "nh os switch --hostname ${host} --update";
    fuaow = "nh os switch --hostname ${host} --update -- --option abort-on-warn true --show-trace";
    frb = "nh os boot --hostname ${host}";
    fub = "nh os boot --hostname ${host} --update";
    nhc = "nh clean all";
    ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
    ls = "ls --color=auto";
    ll = "ls -la";
    lt = "ls -lat";
    icat = "kitten icat";
    logout = "hyprctl dispatch exit";
    man-nixos = "man configuration.nix";
    man-hm = "man home-configuration.nix";
    setup_nix_env = "echo 'use nix' > .envrc && direnv allow";
    arc-login = "ssh -X reub0524@arc-login.arc.ox.ac.uk || ssh -X reub0524@gateway.arc.ox.ac.uk 'ssh -X reub0524@arc-login.arc.ox.ac.uk'";
    arc-htc = "ssh -X reub0524@htc-login.arc.ox.ac.uk || ssh -X reub0524@gateway.arc.ox.ac.uk 'ssh -X reub0524@arc-login.arc.ox.ac.uk'";
    node-login = "ssh shaiikura@10.7.0.3";
    nomad-login = "ssh shaiikura@10.7.0.4";
    reuby-login = "ssh shaiikura@10.7.0.5";
    ag-login = "ssh shaiikura@192.168.1.118";
    prox-login = "ssh shaiikura@192.168.1.43";
    plex-login = "ssh shaiikura@192.168.10.21";

    #Git related aliases
    ggpur = "ggu";
    g = "git";
    gs = "git status";
    ga = "git add";
    gaa = "git add --all";
    gapa = "git add --patch";
    gau = "git add --update";
    gav = "git add --verbose";
    gwip = "git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message ${"--wip-- [skip ci]"}";
    gam = "git am";
    gama = "git am --abort";
    gamc = "git am --continue";
    gamscp = "git am --show-current-patch";
    gams = "git am --skip";
    gap = "git apply";
    gapt = "git apply --3way";
    gbs = "git bisect";
    gbsb = "git bisect bad";
    gbsg = "git bisect good";
    gbsn = "git bisect new";
    gbso = "git bisect old";
    gbsr = "git bisect reset";
    gbss = "git bisect start";
    gbl = "git blame -w";
    gb = "git branch";
    gba = "git branch --all";
    gbd = "git branch --delete";
    gbD = "git branch --delete --force";
    gbm = "git branch --move";
    gbnm = "git branch --no-merged";
    gbr = "git branch --remote";
    ggsup = "git branch --set-upstream-to=origin/$(git_current_branch)";
    gbg = "LANG=C git branch -vv | grep ${": gone\]"}";
    gco = "git checkout";
    gcom = "git commit -m";
    gcoa = "git commit -a -m";
    gcor = "git checkout --recurse-submodules";
    gcb = "git checkout -b";
    gcB = "git checkout -B";
    gcd = "git checkout $(git_develop_branch)";
    gcm = "git checkout $(git_main_branch)";
    gcp = "git cherry-pick";
    gcpa = "git cherry-pick --abort";
    gcpc = "git cherry-pick --continue";
    gclean = "git clean --interactive -d";
    gcl = "git clone --recurse-submodules";
    gclf = "git clone --recursive --shallow-submodules --filter=blob:none --also-filter-submodules";
  };
  inherit (lib) mkOption types;
in {
  options.commonShellAliases = mkOption {
    type = types.nullOr (types.attrsOf types.str);
    default = shellAliases;
    description = ''
      Defines a set of Aliases that can be used across all shells.
      default is my list in "modules/home/shellAliases.nix"
      If null, combining this with other options will be a no-op.
    '';
  };
}
