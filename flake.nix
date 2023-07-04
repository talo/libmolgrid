{
  description = "A very basic flake";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/23.05";

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.callPackage (import ./default.nix) { };

  };
}
