{
  config,
  host,
  inputs,
  pkgs,
  ...
}: let
  inherit
    (import ../../../hosts/${host}/variables.nix)
    extraMonitorSettings
    fileManager
    keyboardLayout
    hostType
    forGaming
    ;

  #Provides bash scripts for handling external and hotplugged monitors
  startMonitorScript =
    if hostType == "Laptop"
    then "/home/shaiikura/.config/hypr/startupscripts/start_monitor.sh"
    else "";
  handleMonitorConnectScript =
    if hostType == "Laptop"
    then "/home/shaiikura/.config/hypr/startupscripts/handle_monitor_connect.sh"
    else "";
  handleMonitorDisconnectScript =
    if hostType == "Laptop"
    then "/home/shaiikura/.config/hypr/startupscripts/handle_monitor_disconnect.sh"
    else "";

  steamExecForGameComputers =
    if forGaming
    then "steam -silent"
    else "";

  #For Desktops with two monitors - sets up workspaces for each monitor
  hostDependentMonitorConfig =
    if hostType == "Desktop"
    then "monitor=,preferred,auto,auto"
    else "";

  AQConfig =
    if host == "reuby"
    then "AQ_DRM_DEVICES,/dev/dri/card1"
    else "AQ_DRM_DEVICES,/dev/dri/card1";
in {
  home.packages = with pkgs; [
    swww
    grim
    slurp
    wl-clipboard
    hyprpolkitagent
    hyprland-qtutils # needed for banners and ANR messages
  ];
  systemd.user.targets.hyprland-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];
  # Place Files Inside Home Directory
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    plugins = [
      #inputs.hyprspace.packages.${pkgs.system}.Hyprspace
    ];
    systemd = {
      enable = true;
      enableXdgAutostart = true;
      variables = ["--all"];
    };
    xwayland = {
      enable = true;
    };
    settings = {
      exec-once = [
        "hyprpanel"
        "waypaper --restore"
        "/home/shaiikura/.config/waypaper/autopicker.sh"
        "dbus-update-activation-environment --all --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user start hyprpolkitagent"
        "timeout 10s bash -c 'sshfs reub0524@arc-login.arc.ox.ac.uk:/data/biol-synoxys-epi/reub0524 /home/shaiikura/biol-synoxys-epi'"
        "sleep 1; pypr &"
        # "[workspace special:outlook silent] firefox -P outlook -no-remote -new-instance https://outlook.office.com/mail/ https://unioxfordnexus-my.sharepoint.com/my"
        startMonitorScript
        handleMonitorConnectScript
        handleMonitorDisconnectScript
        steamExecForGameComputers
      ];
      execr = [
        startMonitorScript
        handleMonitorConnectScript
        handleMonitorDisconnectScript
      ];
      input = {
        kb_layout = "${keyboardLayout}";
        kb_options = [
          "grp:alt_caps_toggle"
          "caps:super"
        ];
        numlock_by_default = true;
        repeat_delay = 350;
        repeat_rate = 50;
        follow_mouse = 1;
        float_switch_override_focus = 0;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          scroll_factor = 0.8;
        };
      };

      gestures = {
        workspace_swipe_distance = 500;
        workspace_swipe_invert = 1;
        workspace_swipe_min_speed_to_force = 30;
        workspace_swipe_cancel_ratio = 0.5;
        workspace_swipe_create_new = 1;
        workspace_swipe_forever = 1;
      };

      general = {
        "$modifier" = "SUPER";
        "$fileManager" = fileManager;
        "$menu" = "rofi -show drun";
        layout = "dwindle";
        gaps_in = 6;
        gaps_out = 8;
        border_size = 2;
        resize_on_border = true;
        "col.active_border" = "rgba(ffffffff) rgba(000000ff) 45deg";
        "col.inactive_border" = "rgba(00000000)";
      };

      misc = {
        layers_hog_keyboard_focus = true;
        initial_workspace_tracking = 0;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = false;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        enable_swallow = false;
        vfr = true; # Variable Frame Rate
        vrr = 2; #Variable Refresh Rate  Might need to set to 0 for NVIDIA/AQ_DRM_DEVICES
        # Screen flashing to black momentarily or going black when app is fullscreen
        # Try setting vrr to 0

        #  Application not responding (ANR) settings
        enable_anr_dialog = false;
        # anr_missed_pings = 20;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        force_split = 2;
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 5;
          passes = 3;
          ignore_opacity = false;
          new_optimizations = true;
        };
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };
      cursor = {
        sync_gsettings_theme = true;
        no_hardware_cursors = 2; # change to 1 if want to disable
        enable_hyprcursor = false;
        warp_on_change_workspace = 2;
        no_warps = true;
      };

      render = {
        direct_scanout = 0;
      };

      master = {
        new_status = "master";
        new_on_top = 1;
        mfact = 0.5;
      };

      env = [
        "NIXOS_OZONE_WL, 1"
        "NIXPKGS_ALLOW_UNFREE, 1"
        "XDG_CURRENT_DESKTOP, Hyprland"
        "XDG_SESSION_TYPE, wayland"
        "XDG_SESSION_DESKTOP, Hyprland"
        "GDK_BACKEND, wayland, x11"
        "CLUTTER_BACKEND, wayland"
        "QT_QPA_PLATFORM=wayland;xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"
        "QT_AUTO_SCREEN_SCALE_FACTOR, 1"
        "SDL_VIDEODRIVER, x11"
        "MOZ_ENABLE_WAYLAND, 1"
        AQConfig
        "GDK_SCALE,1"
        "QT_SCALE_FACTOR,1"
        "EDITOR,nvim"
      ];
    };
    extraConfig = "
      ${hostDependentMonitorConfig}
      ${extraMonitorSettings}
    ";
  };
}
