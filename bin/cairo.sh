#!/usr/bin/env bash
# bin/compile <build-dir> <cache-dir>

# watch out for CPPPATH/CPATH/LIBPATH, each library can vary
# These files should be built for Heroku by Vulcan.

function cairo_vendor() {
  binary="$1"
  path="$2"
  include="$3"

  echo "       Fetching $binary"
  mkdir -p $path
  package="https://s3.amazonaws.com/sr-public/libs/$binary"
  curl $package -s -o - | tar xz -C $path -f -

  echo "       Exporting $binary build and include paths"

  export CPPPATH="$path/$include:$CPPPATH"
  export CPATH="$path/$include:$CPATH"
  export LIBRARY_PATH="$path/lib:$LIBRARY_PATH"
  export PKG_CONFIG_PATH="$path/lib/pkgconfig:$PKG_CONFIG_PATH"
}

echo "-----> Vendoring Cairo"
cairo_vendor "cairo-1.12.6.gz" "$1/vendor/cairo-1.12" "include/cairo"
cairo_vendor "pixman-0.28.0.gz" "$1/vendor/pixman-0.28" "include/pixman-1"