# These can be passed to nixpkgs as either the `localSystem` or
# `crossSystem`. They are put here for user convenience, but also used by cross
# tests and linux cross stdenv building, so handle with care!
{ lib }:
let
  platforms = import ./platforms.nix { inherit lib; };

  riscv = bits: {
    config = "riscv${bits}-unknown-linux-gnu";
  };
in

rec {
  #
  # Linux
  #
  powernv = {
    config = "powerpc64le-unknown-linux-gnu";
  };
  musl-power = {
    config = "powerpc64le-unknown-linux-musl";
  };

  ppc64-elfv1 = {
    config = "powerpc64-unknown-linux-gnuabielfv1";
    rust.rustcTarget = "powerpc64-unknown-linux-gnu";
  };
  ppc64-elfv2 = {
    config = "powerpc64-unknown-linux-gnuabielfv2";
  };
  ppc64 = ppc64-elfv2;
  ppc64-musl = {
    config = "powerpc64-unknown-linux-musl";
    gcc = {
      abi = "elfv2";
    };
  };

  sheevaplug = {
    config = "armv5tel-unknown-linux-gnueabi";
  }
  // platforms.sheevaplug;

  raspberryPi = {
    config = "armv6l-unknown-linux-gnueabihf";
  }
  // platforms.raspberrypi;

  bluefield2 = {
    config = "aarch64-unknown-linux-gnu";
  }
  // platforms.bluefield2;

  remarkable1 = {
    config = "armv7l-unknown-linux-gnueabihf";
  }
  // platforms.zero-gravitas;

  remarkable2 = {
    config = "armv7l-unknown-linux-gnueabihf";
  }
  // platforms.zero-sugar;

  armv7l-hf-multiplatform = {
    config = "armv7l-unknown-linux-gnueabihf";
  };

  aarch64-multiplatform = {
    config = "aarch64-unknown-linux-gnu";
  };

  armv7a-android-prebuilt = {
    config = "armv7a-unknown-linux-androideabi";
    rust.rustcTarget = "armv7-linux-androideabi";
    androidSdkVersion = "33";
    androidNdkVersion = "26";
    useAndroidPrebuilt = true;
  }
  // platforms.armv7a-android;

  aarch64-android-prebuilt = {
    config = "aarch64-unknown-linux-android";
    rust.rustcTarget = "aarch64-linux-android";
    androidSdkVersion = "33";
    androidNdkVersion = "26";
    useAndroidPrebuilt = true;
  };

  aarch64-android = {
    config = "aarch64-unknown-linux-android";
    androidSdkVersion = "33";
    androidNdkVersion = "26";
    libc = "bionic";
    useAndroidPrebuilt = false;
    useLLVM = true;
  };

  pogoplug4 = {
    config = "armv5tel-unknown-linux-gnueabi";
  }
  // platforms.pogoplug4;

  ben-nanonote = {
    config = "mipsel-unknown-linux-uclibc";
  }
  // platforms.ben_nanonote;

  fuloongminipc = {
    config = "mipsel-unknown-linux-gnu";
  }
  // platforms.fuloong2f_n32;

  # can execute on 32bit chip
  mips-linux-gnu = {
    config = "mips-unknown-linux-gnu";
  }
  // platforms.gcc_mips32r2_o32;
  mipsel-linux-gnu = {
    config = "mipsel-unknown-linux-gnu";
  }
  // platforms.gcc_mips32r2_o32;

  # require 64bit chip (for more registers, 64-bit floating point, 64-bit "long long") but use 32bit pointers
  mips64-linux-gnuabin32 = {
    config = "mips64-unknown-linux-gnuabin32";
  }
  // platforms.gcc_mips64r2_n32;
  mips64el-linux-gnuabin32 = {
    config = "mips64el-unknown-linux-gnuabin32";
  }
  // platforms.gcc_mips64r2_n32;

  # 64bit pointers
  mips64-linux-gnuabi64 = {
    config = "mips64-unknown-linux-gnuabi64";
  }
  // platforms.gcc_mips64r2_64;
  mips64el-linux-gnuabi64 = {
    config = "mips64el-unknown-linux-gnuabi64";
  }
  // platforms.gcc_mips64r2_64;

  muslpi = raspberryPi // {
    config = "armv6l-unknown-linux-musleabihf";
  };

  aarch64-multiplatform-musl = {
    config = "aarch64-unknown-linux-musl";
  };

  gnu64 = {
    config = "x86_64-unknown-linux-gnu";
  };
  gnu64_simplekernel = gnu64 // platforms.pc_simplekernel; # see test/cross/default.nix
  gnu32 = {
    config = "i686-unknown-linux-gnu";
  };

  musl64 = {
    config = "x86_64-unknown-linux-musl";
  };
  musl32 = {
    config = "i686-unknown-linux-musl";
  };

  riscv64 = riscv "64";
  riscv32 = riscv "32";

  riscv64-musl = {
    config = "riscv64-unknown-linux-musl";
  };

  riscv64-embedded = {
    config = "riscv64-none-elf";
    libc = "newlib";
  };

  riscv32-embedded = {
    config = "riscv32-none-elf";
    libc = "newlib";
  };

  mips64-embedded = {
    config = "mips64-none-elf";
    libc = "newlib";
  };

  mips-embedded = {
    config = "mips-none-elf";
    libc = "newlib";
  };

  # https://github.com/loongson/la-softdev-convention/blob/master/la-softdev-convention.adoc#10-operating-system-package-build-requirements
  loongarch64-linux = lib.recursiveUpdate platforms.loongarch64-multiplatform {
    config = "loongarch64-unknown-linux-gnu";
  };
  loongarch64-linux-embedded = lib.recursiveUpdate platforms.loongarch64-multiplatform {
    config = "loongarch64-unknown-linux-gnu";
    gcc = {
      arch = "loongarch64";
      strict-align = true;
    };
  };

  mmix = {
    config = "mmix-unknown-mmixware";
    libc = "newlib";
  };

  rx-embedded = {
    config = "rx-none-elf";
    libc = "newlib";
  };

  msp430 = {
    config = "msp430-elf";
    libc = "newlib";
  };

  avr = {
    config = "avr";
  };

  vc4 = {
    config = "vc4-elf";
    libc = "newlib";
  };

  or1k = {
    config = "or1k-elf";
    libc = "newlib";
  };

  m68k = {
    config = "m68k-unknown-linux-gnu";
  };

  s390 = {
    config = "s390-unknown-linux-gnu";
  };

  s390x = {
    config = "s390x-unknown-linux-gnu";
  };

  arm-embedded = {
    config = "arm-none-eabi";
    libc = "newlib";
  };
  arm-embedded-nano = {
    config = "arm-none-eabi";
    libc = "newlib-nano";
  };
  armhf-embedded = {
    config = "arm-none-eabihf";
    libc = "newlib";
    # GCC8+ does not build without this
    # (https://www.mail-archive.com/gcc-bugs@gcc.gnu.org/msg552339.html):
    gcc = {
      arch = "armv5t";
      fpu = "vfp";
    };
  };

  aarch64-embedded = {
    config = "aarch64-none-elf";
    libc = "newlib";
    rust.rustcTarget = "aarch64-unknown-none";
  };

  aarch64be-embedded = {
    config = "aarch64_be-none-elf";
    libc = "newlib";
  };

  ppc-embedded = {
    config = "powerpc-none-eabi";
    libc = "newlib";
  };

  ppcle-embedded = {
    config = "powerpcle-none-eabi";
    libc = "newlib";
  };

  i686-embedded = {
    config = "i686-elf";
    libc = "newlib";
  };

  x86_64-embedded = {
    config = "x86_64-elf";
    libc = "newlib";
  };

  microblaze-embedded = {
    config = "microblazeel-none-elf";
    libc = "newlib";
  };

  #
  # Redox
  #

  x86_64-unknown-redox = {
    config = "x86_64-unknown-redox";
    libc = "relibc";
  };

  #
  # Darwin
  #

  iphone64 = {
    config = "arm64-apple-ios";
    # config = "aarch64-apple-darwin14";
    darwinSdkVersion = "14.3";
    xcodeVer = "12.3";
    xcodePlatform = "iPhoneOS";
    useiOSPrebuilt = true;
  };

  iphone64-simulator = {
    config = "x86_64-apple-ios";
    # config = "x86_64-apple-darwin14";
    darwinSdkVersion = "14.3";
    xcodeVer = "12.3";
    xcodePlatform = "iPhoneSimulator";
    darwinPlatform = "ios-simulator";
    useiOSPrebuilt = true;
  };

  aarch64-darwin = {
    config = "arm64-apple-darwin";
    xcodePlatform = "MacOSX";
    platform = { };
  };

  x86_64-darwin = {
    config = "x86_64-apple-darwin";
    xcodePlatform = "MacOSX";
    platform = { };
  };

  #
  # Windows
  #

  # 32 bit mingw-w64
  mingw32 = {
    config = "i686-w64-mingw32";
    libc = "msvcrt"; # This distinguishes the mingw (non posix) toolchain
  };

  # 64 bit mingw-w64
  mingwW64 = {
    # That's the triplet they use in the mingw-w64 docs.
    config = "x86_64-w64-mingw32";
    libc = "msvcrt"; # This distinguishes the mingw (non posix) toolchain
  };

  ucrt64 = {
    config = "x86_64-w64-mingw32";
    libc = "ucrt"; # This distinguishes the mingw (non posix) toolchain
  };

  # LLVM-based mingw-w64 for ARM
  ucrtAarch64 = {
    config = "aarch64-w64-mingw32";
    libc = "ucrt";
    rust.rustcTarget = "aarch64-pc-windows-gnullvm";
    useLLVM = true;
  };

  # Target the MSVC ABI
  x86_64-windows = {
    config = "x86_64-pc-windows-msvc";
    useLLVM = true;
  };

  aarch64-windows = {
    config = "aarch64-pc-windows-msvc";
    useLLVM = true;
  };

  # BSDs

  aarch64-freebsd = {
    config = "aarch64-unknown-freebsd";
    useLLVM = true;
  };

  x86_64-freebsd = {
    config = "x86_64-unknown-freebsd";
    useLLVM = true;
  };

  x86_64-netbsd = {
    config = "x86_64-unknown-netbsd";
  };

  # this is broken and never worked fully
  x86_64-netbsd-llvm = {
    config = "x86_64-unknown-netbsd";
    useLLVM = true;
  };

  x86_64-openbsd = {
    config = "x86_64-unknown-openbsd";
    useLLVM = true;
  };

  #
  # WASM
  #

  wasi32 = {
    config = "wasm32-unknown-wasi";
    useLLVM = true;
  };

  wasm32-unknown-none = {
    config = "wasm32-unknown-none";
    rust.rustcTarget = "wasm32-unknown-unknown";
    useLLVM = true;
  };

  # Ghcjs
  ghcjs = {
    # This triple is special to GHC/Cabal/GHCJS and not recognized by autotools
    # See: https://gitlab.haskell.org/ghc/ghc/-/commit/6636b670233522f01d002c9b97827d00289dbf5c
    # https://github.com/ghcjs/ghcjs/issues/53
    config = "javascript-unknown-ghcjs";
  };
}
