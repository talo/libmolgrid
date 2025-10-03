{
  lib,
  cmake,
  boost,
  python3,
  python3Packages,
  cudaPackages,
  openbabel,
  zlib,
}:

cudaPackages.backendStdenv.mkDerivation {
  pname = "libmolgrid";
  version = "master";
  src = ./.;

  nativeBuildInputs = [
    cmake
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    boost.dev
    python3
    python3Packages.boost
    python3Packages.numpy
    python3Packages.openbabel-bindings
    python3Packages.pyquaternion
    python3Packages.pytest
    cudaPackages.cuda_cudart
    cudaPackages.cuda_cccl
    openbabel
    zlib
  ];

  cmakeFlags = [
    "-DCMAKE_CUDA_ARCHITECTURES=70;80;86"
    "-DOPENBABEL3_INCLUDE_DIR=${openbabel}/include/openbabel3"
  ];

  meta = with lib; {
    description = "Comprehensive library for fast, GPU accelerated molecular gridding for deep learning workflows";
    homepage = "https://github.com/gnina/libmolgrid";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
