{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";

    fenix = {
      url = "github:nix-community/fenix/monthly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      utils,
      ...
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        rust =
          with inputs.fenix.packages.${system};
          combine [
            complete.toolchain
            targets.wasm32-unknown-unknown.latest.rust-std
          ];
      in
      with pkgs;
      {
        devShell = mkShell {
          strictDeps = true;

          LD_LIBRARY_PATH = lib.makeLibraryPath [ openssl ];

          nativeBuildInputs = [
            rust
            pkg-config
          ];

          buildInputs = [
            openssl
          ];

          packages = [
            dioxus-cli
          ];
        };
      }
    );
}
