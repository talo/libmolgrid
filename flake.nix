{
  description = "A very basic flake";
  #inputs.nixpkgs.url = "github:NixOS/nixpkgs/22.11";
  inputs.nixpkgs-base.url = "github:NixOS/nixpkgs/22.11";
  inputs.nixpkgs.url = "github:numtide/nixpkgs-unfree/7331a9526557393edc2ff86d04ecd74b107f1b81";
  inputs.nixpkgs.inputs.nixpkgs.follows = "nixpkgs-base";

  outputs = { self, nixpkgs, nixpkgs-base }: {

    packages.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.callPackage (import ./default.nix) { };

  };
}
