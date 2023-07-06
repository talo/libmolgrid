{ lib
, stdenv
, fetchFromGitHub
, cmake
, cudatoolkit
, openbabel
, zlib
, boost
, python310Packages
, python310
, pkgconfig
, llvmPackages_15
, libcxx
, icu72
, gcc
}:

stdenv.mkDerivation rec {
  pname = "libmolgrid";
  version = "0.5.3";

  src = ./.;
  # fetchFromGitHub {
  #   owner = "gnina";
  #   repo = "libmolgrid";
  #   rev = "v${version}";
  #   hash = "sha256-YdEjXfrTf9hw0nMbC2JWZ7Gf/psZ4RQ6v6GUrx5yIoA=";
  # };

  #buildFlags = [ "-stdlib=libstdc++" ];

  nativeBuildInputs = [
    cmake
    pkgconfig
    libcxx
  ];

  buildInputs = [
    gcc
    cudatoolkit
    libcxx
    openbabel
    #stdenv.cc.cc.lib
    zlib
    boost.dev
    python310Packages.boost
    python310Packages.pytest
    python310Packages.numpy
    python310Packages.pyquaternion
    python310Packages.openbabel-bindings
    python310
  ];

  OPENBABEL3_INCLUDE_DIR = "${openbabel}/include/openbabel3";

  cmakeFlags = [ "-DOPENBABEL3_INCLUDE_DIR=${OPENBABEL3_INCLUDE_DIR}" ];

  meta = with lib; {
    description =
      "Comprehensive library for fast, GPU accelerated molecular gridding for deep learning workflows";
    homepage = "https://github.com/gnina/libmolgrid";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
