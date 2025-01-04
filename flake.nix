{
  description = "Hugo development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            hugo
            nodejs # For asset pipeline
            go # Required for some Hugo features
            
            # Optional but useful tools
            pre-commit
            nodePackages.prettier
            git
          ];

          shellHook = ''
            echo "Hugo development environment activated"
            echo "Run 'hugo server' to start the development server"
          '';
        };
      }
    );
}
