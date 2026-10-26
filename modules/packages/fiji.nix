{
  symlinkJoin,
  makeWrapper,
  gtk3,
  fiji,
}: let
  # Fiji's bundled JRE loads the GTK Look-and-Feel for Swing dialogs, which
  # needs the glib schemas at runtime; without it the Open file picker fails.
  gsettingsSchemaDir = "${gtk3.out}/share/gsettings-schemas/${gtk3.name}/glib-2.0/schemas";
in
  symlinkJoin {
    name = "fiji-with-gtk-schema";
    paths = [fiji];

    nativeBuildInputs = [makeWrapper];

    postBuild = ''
      wrapProgram $out/bin/fiji \
        --set GSETTINGS_SCHEMA_DIR "${gsettingsSchemaDir}"
    '';
  }
