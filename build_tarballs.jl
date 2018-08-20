# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

# Collection of sources required to build x265Builder
sources = [
    "https://bitbucket.org/multicoreware/x265/downloads/x265_2.8.tar.gz" =>
    "6e59f9afc0c2b87a46f98e33b5159d56ffb3558a49d8e3d79cb7fdc6b7aaa863",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd x265_2.8/
mkdir bld && cd bld
cmake -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain ../source
make -j${nproc}
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    Linux(:i686, :musl),
    Linux(:x86_64, :musl),
    MacOS(:x86_64),
    FreeBSD(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libx265", :libx265),
    ExecutableProduct(prefix, "", :x265)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "x265Builder", sources, script, platforms, products, dependencies)

