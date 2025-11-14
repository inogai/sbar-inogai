{pkgs ? import <nixpkgs> {}}: let
  pname = "sbar-inogai";
  wrapper = pkgs.writeScriptBin pname ''
    exec -a ${pname} ${pkgs.sketchybar}/bin/sketchybar "$@"
  '';
in
  pkgs.stdenv.mkDerivation (finalattrs: {
    pname = pname;
    version = "1.0.0";

    src = ./.;

    buildInputs = [
      pkgs.makeWrapper
    ];

    installPhase = ''
      mkdir -p $out/bin $out/config
      cp ${wrapper}/bin/${pname} $out/bin/
      cp -r $src/config $out/config/${pname}
    '';

    postFixup = ''
      wrapProgram $out/bin/${pname} \
        --set XDG_CONFIG_HOME $out/config \
        --prefix PATH : ${pkgs.lib.makeBinPath [pkgs.sketchybar pkgs.sbarlua]} \
        --prefix LUA_CPATH \; "${pkgs.sbarlua}/lib/lua/5.4/?.so"
    '';
  })
