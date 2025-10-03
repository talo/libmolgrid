{
  description = "A flake for libmolgrid.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/32a4e87942101f1c9f9865e04dc3ddb175f5f32e";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.cudaSupport = true;
        config.cudaCapabilities = [
          "7.0"
          "8.0"
          "8.6"
        ];
        cudaForwardCompat = false;
      };
    in
    {
      packages.${system} = {
        libmolgrid = pkgs.callPackage (import ./default.nix) {
          cudaPackages = pkgs.cudaPackages_12_4;
        };
        default = self.packages.${system}.libmolgrid;
      };
    };
}
