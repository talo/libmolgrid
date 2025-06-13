{
  description = "A flake for libmolgrid.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs =
    { self, nixpkgs }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
        config.cudaSupport = true;
        config.cudaCapabilities = [
          "7.0"
          "8.0"
          "8.6"
        ];
      };
    in
    {
      packages.x86_64-linux.libmolgrid = pkgs.callPackage (import ./default.nix) { };
      packages.x86_64-linux.default = self.packages.x86_64-linux.libmolgrid;
    };
}
