# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "x265Builder"
version = v"3.0"

# Collection of sources required to build x265Builder
sources = [
    "http://ftp.videolan.org/pub/videolan/x265/x265_3.0.tar.gz" =>
    "c5b9fc260cabbc4a81561a448f4ce9cad7218272b4011feabc3a6b751b2f0662",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd x265_3.0/
apk add nasm
nasm --version
mkdir bld && cd bld
cmake -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain  ../source
make -j${nproc}
make install
rm -vf $prefix/lib/libx265.a

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    # Windows
    Windows(:i686),
    Windows(:x86_64),

    # linux
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    #Linux(:aarch64, :glibc),
    Linux(:armv7l, :glibc),
    Linux(:powerpc64le, :glibc),

    # musl
    Linux(:i686, :musl),
    Linux(:x86_64, :musl),
    #Linux(:aarch64, :musl),
    Linux(:armv7l, :musl),

    # The BSD's
    FreeBSD(:x86_64),
    MacOS(:x86_64),
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libx265", :libx265),
    ExecutableProduct(prefix, "x265", :x265)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

