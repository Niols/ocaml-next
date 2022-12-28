{
  inputs = {
    opam-nix.url = github:tweag/opam-nix;
    nixpkgs.follows = "opam-nix/nixpkgs";

    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = { self, nixpkgs, opam-nix, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:

      let pkgs = import nixpkgs { inherit system; };
          on = opam-nix.lib.${system};

          packages = on.buildDuneProject { pkgs = pkgs; } "next" ./. {
            merlin = "*";
            ocaml-base-compiler = "*";
            ocaml-lsp-server = "*";
            ocp-indent = "*";
            utop = "*";
          };
      in
        {
          packages = packages // {
            default = packages.next;
          };

          devShells.default = pkgs.mkShell {
            buildInputs = [
              packages.merlin
              packages.ocaml-lsp-server
              packages.ocp-indent
              packages.utop
            ];
            inputsFrom = [ packages.next ];
          };
        });
}
