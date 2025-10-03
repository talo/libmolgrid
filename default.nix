{
  lib,
  stdenv,
  cmake,
  pkg-config,
  boost,
  cudaPackages,
  python3,
  python3Packages,
  openbabel,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "libmolgrid";
  version = "master";
  src = ./.;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost.dev
    cudaPackages.cuda_cccl
    cudaPackages.cuda_cudart
    cudaPackages.cuda_nvcc
    python3
    python3Packages.boost
    python3Packages.numpy
    python3Packages.openbabel-bindings
    python3Packages.pyquaternion
    python3Packages.pytest
    openbabel
    zlib
  ];

  OPENBABEL3_INCLUDE_DIR = "${openbabel}/include/openbabel3";

  cmakeFlags = [
    "-DOPENBABEL3_INCLUDE_DIR=${OPENBABEL3_INCLUDE_DIR}"
    "-DCMAKE_CUDA_ARCHITECTURES=70;80;86"
  ];

  meta = with lib; {
    description = "Comprehensive library for fast, GPU accelerated molecular gridding for deep learning workflows";
    homepage = "https://github.com/gnina/libmolgrid";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
