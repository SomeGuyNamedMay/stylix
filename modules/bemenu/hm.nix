{pkgs, config, lib, ... }:

with config.stylix.colors.withHashtag;
with config.stylix.fonts;
{
  options.stylix.targets.bemenu = {
    enable = config.lib.stylix.mkEnableTarget "bemenu" true;

    fontSize = lib.mkOption {
      description = lib.mdDoc ''
        Font size used for bemenu.
      '';
      type = with lib.types; nullOr int;
      default = sizes.popups;
    }; # optional argument

    alternate = lib.mkOption {
      description = lib.mdDoc ''
        Whether to use alternating colours.
      '';
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf config.stylix.targets.bemenu.enable {
    home.sessionVariables.BEMENU_OPTS =
      with config.stylix.targets.bemenu;
      let
        opacity = config.lib.stylix.opacityToHex config.stylix.opacity.popups;
      in
      builtins.concatStringsSep " " [
        # Inspired from https://git.sr.ht/~h4n1/base16-bemenu_opts
        "--tb '${base01}${opacity}'"
        "--nb '${base01}${opacity}'"
        "--fb '${base01}${opacity}'"
        "--hb '${base03}${opacity}'"
        "--sb '${base03}${opacity}'"
        "--hf '${base0A}'"
        "--sf '${base0B}'"
        "--tf '${base05}'"
        "--ff '${base05}'"
        "--nf '${base05}'"
        "--scb '${base01}'"
        "--scf '${base03}'"
        "--ab '${if alternate then base00 else base01}'"
        "--af '${if alternate then base04 else base05}'"
        "--fn '${sansSerif.name} ${lib.optionalString (fontSize != null) (builtins.toString fontSize)}'"
      ];
  };
}
