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
      {
        devShell = pkgs.mkShell {
          packages = with pkgs; [
            rust
            dioxus-cli
          ];
        };
      }
    );
}
