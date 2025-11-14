{
  description = "Sketchybar flake with sbar-inogai wrapper";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    nixpkgs,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem = {
        pkgs,
        system,
        ...
      }: {
        packages.default = pkgs.callPackage ./package.nix {};
        packages.sbar-inogai = pkgs.callPackage ./package.nix {};

        devShells = {
          default = pkgs.mkShellNoCC {
            packages = with pkgs; [
              lua-language-server
              stylua
            ];
          };
        };
      };
    };
}
