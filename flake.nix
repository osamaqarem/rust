{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
        let
            pkgs = import nixpkgs { inherit system; };
            isDarwin = pkgs.stdenv.isDarwin;
        in {
            devShells.default = with pkgs; mkShell {
                buildInputs = [
                    cargo
                    rustc
                ] ++ lib.optional isDarwin [
                        darwin.apple_sdk.frameworks.CoreServices
                        libiconv
                    ];

                shellHook = ''
                  export PATH=$PATH:$HOME/.cargo/bin
                '';
                RUST_SRC_PATH = rustPlatform.rustLibSrc;
            };
        }
    );
}
