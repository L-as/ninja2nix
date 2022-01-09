{ mkDerivation, aeson, aeson-pretty, base, bytestring
, concurrent-supply, containers, flow, hashable, language-ninja
, lens, lib,  mtl, prettyprinter
, prettyprinter-ansi-terminal, text, transformers
, unordered-containers
}:
mkDerivation {
  pname = "ninja2nix";
  version = "0.1.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson aeson-pretty base bytestring concurrent-supply containers
    flow hashable language-ninja lens mtl prettyprinter
    prettyprinter-ansi-terminal text transformers unordered-containers
  ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [ base ];
  homepage = "https://github.com/L-as/ninja2nix";
  description = "Convert a Ninja build file into a Nix derivation";
  license = lib.licenses.asl20;
}
