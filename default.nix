{ lib
, stdenv
, fetchFromGitHub
, cmake
, cudaPackages
, openbabel
, zlib
, boost
, python3
, python3Packages
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "libmolgrid";
  version = "master";
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
    pkg-config
  ];

  buildInputs = [
    #gcc
    cudaPackages.cuda_cccl
    cudaPackages.cuda_cudart
    cudaPackages.cuda_nvcc
    openbabel
    #stdenv.cc.cc.lib
    zlib
    boost.dev
    python3
    python3Packages.boost
    python3Packages.numpy
    python3Packages.openbabel-bindings
    python3Packages.pyquaternion
    python3Packages.pytest
  ];

  OPENBABEL3_INCLUDE_DIR = "${openbabel}/include/openbabel3";

  cmakeFlags = [
    "-DOPENBABEL3_INCLUDE_DIR=${OPENBABEL3_INCLUDE_DIR}"
    "-DCMAKE_CUDA_ARCHITECTURES=70;80;86"
  ];

  meta = with lib; {
    description =
      "Comprehensive library for fast, GPU accelerated molecular gridding for deep learning workflows";
    homepage = "https://github.com/gnina/libmolgrid";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
