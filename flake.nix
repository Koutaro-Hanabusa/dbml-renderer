{
  description = "DBML Renderer (forked). CLI that renders DBML to SVG via viz.js (Graphviz WASM).";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        dbml-renderer = pkgs.buildNpmPackage {
          pname = "dbml-renderer";
          version = "1.0.31";
          src = ./.;

          # `nix build` の初回に nix が期待するハッシュを教えてくれるので、
          # そのハッシュに差し替える (buildNpmPackage は fake hash から実 hash 提示)
          npmDepsHash = "sha256-MPK+atDS4fwycDfAXMoofWFo8JVS8ozBjGXGBeZJy6I=";

          # 生成物 (lib/) を含めるため build を通す
          npmBuildScript = "build";

          meta = with pkgs.lib; {
            description = "Render DBML files to SVG (viz.js/Graphviz backend)";
            homepage = "https://github.com/Koutaro-Hanabusa/dbml-renderer";
            license = licenses.isc;
            mainProgram = "dbml-renderer";
          };
        };
      in
      {
        packages = {
          default = dbml-renderer;
          dbml-renderer = dbml-renderer;
        };

        apps.default = flake-utils.lib.mkApp {
          drv = dbml-renderer;
        };
      });
}
