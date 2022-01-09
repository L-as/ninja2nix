{
  description = "ninja2nix";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs?rev=dfc501756b09fa40f9eeb4a1c12ccd225ba3e3d8";
  inputs.language-ninja.url = "github:L-as/language-ninja";
  inputs.language-ninja.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, language-ninja }:
  let
    supportedSystems = with nixpkgs.lib.systems.supported; tier1 ++ tier2 ++ tier3;
    perSystem = nixpkgs.lib.genAttrs supportedSystems;
    nixpkgsFor = system: import nixpkgs { inherit system; overlays = [ self.overlay ]; };

    haskellOverlay' = pkgs: lib: final: prev: {
      ninja2nix = final.callPackage ./ninja2nix.nix {};
    };
  in
  {
    haskellOverlay = pkgs:
      let lib = pkgs.haskell.lib.compose; in
      nixpkgs.lib.composeExtensions (haskellOverlay' pkgs lib) (language-ninja.haskellOverlay pkgs);

    overlay = final: prev: {
      haskellPackages = prev.haskellPackages.override {
        overrides = self.haskellOverlay final;
      };
    };

    packages = perSystem (system: {
      inherit ((nixpkgsFor system).haskellPackages) ninja2nix;
    });
    defaultPackage = perSystem (system: self.packages.${system}.ninja2nix);

    devShell = perSystem (system:
      let pkgs = nixpkgsFor system; in
      pkgs.haskellPackages.shellFor {
        packages = p: [ p.ninja2nix ];
        withHoogle = true;
        buildInputs = [ pkgs.cabal-install pkgs.cabal2nix ];
      }
    );
  };
}

