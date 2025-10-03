{
  description = "A flake for libmolgrid.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/32a4e87942101f1c9f9865e04dc3ddb175f5f32e";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
    in
    {
      packages.${system} = {
        libmolgrid =
          let
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
              config.cudaSupport = true;
            };
          in
          pkgs.callPackage ./default.nix { };
        libmolgrid_bullet =
          let
            system = "x86_64-linux";
            pkgs = import nixpkgs {
              inherit system;
              overlays = [
                (final: prev: { cudaPackages = prev.cudaPackages_12_4; })
              ];
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
          pkgs.callPackage ./default.nix { };
        default = self.packages.${system}.libmolgrid;
      };
    };
}
