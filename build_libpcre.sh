#!/bin/sh
mkdir -p build
cd build
mkdir -p libpcre
cd libpcre
CURRENTPATH=`pwd`
LIB_VERSION="8.43"
SDK_VERSION=`xcrun -sdk iphoneos --show-sdk-version`
ARCHS="i386 x86_64 armv7 armv7s arm64"
DEVELOPER=`xcode-select -print-path`
if [ ! -d "$DEVELOPER" ]; then
  echo "xcode path is not set correctly $DEVELOPER does not exist (most likely because of xcode > 4.3)"
  echo "run"
  echo "sudo xcode-select -switch <xcode path>"
  echo "for default installation:"
  echo "sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer"
  exit 1
fi
case $DEVELOPER in  
     *\ * )
           echo "Your Xcode path contains whitespaces."
           exit 1
          ;;
esac
case $PWD in  
     *\ * )
           echo "Your path contains whitespaces."
           exit 1
          ;;
esac

set -e
if [ ! -e "pcre-${LIB_VERSION}.zip" ]
then
    curl -L -O "https://ftp.pcre.org/pub/pcre/pcre-${LIB_VERSION}.zip"
fi

unzip -q -o pcre-${LIB_VERSION}.zip 
cd "pcre-${LIB_VERSION}"

for ARCH in ${ARCHS}
do
if [[ "${ARCH}" == "i386" || "${ARCH}" == "x86_64" ]];
then
PLATFORM="iPhoneSimulator"
else
PLATFORM="iPhoneOS"
fi

export BUILD_TOOLS="${DEVELOPER}"
export BUILD_DEVROOT="${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer"
export BUILD_SDKROOT="${BUILD_DEVROOT}/SDKs/${PLATFORM}${SDKVERSION}.sdk"

export CC="${BUILD_TOOLS}/usr/bin/gcc -arch ${ARCH}"
mkdir -p "${CURRENTPATH}/bin/${PLATFORM}${SDKVERSION}-${ARCH}.sdk"

# Build
export LDFLAGS="-Os -arch ${ARCH} -Wl,-dead_strip -L${BUILD_SDKROOT}/usr/lib -miphoneos-version-min=8.0"
export CFLAGS="-Os -arch ${ARCH} -pipe -no-cpp-precomp -isysroot ${BUILD_SDKROOT} -miphoneos-version-min=8.0"
export CPPFLAGS="${CFLAGS} -I${BUILD_SDKROOT}/usr/include"
export CXXFLAGS="${CPPFLAGS}"

if [ "${ARCH}" == "arm64" ]; then
./configure --host=aarch64-apple-darwin --enable-static --disable-shared --enable-utf8
else
./configure --host=${ARCH}-apple-darwin --enable-static --disable-shared --enable-utf8
fi

make
cp -f .libs/libpcre.a ${CURRENTPATH}/bin/${PLATFORM}${SDKVERSION}-${ARCH}.sdk/
make clean

done

cd $CURRENTPATH
mkdir -p lib 
lipo -create ${CURRENTPATH}/bin/iPhoneSimulator${SDKVERSION}-i386.sdk/libpcre.a ${CURRENTPATH}/bin/iPhoneSimulator${SDKVERSION}-x86_64.sdk/libpcre.a  ${CURRENTPATH}/bin/iPhoneOS${SDKVERSION}-armv7.sdk/libpcre.a ${CURRENTPATH}/bin/iPhoneOS${SDKVERSION}-armv7s.sdk/libpcre.a ${CURRENTPATH}/bin/iPhoneOS${SDKVERSION}-arm64.sdk/libpcre.a -output ${CURRENTPATH}/lib/libpcre.a
mkdir -p include
cp -rf pcre-${LIB_VERSION}/*.h include/

rm -rf pcre-${LIB_VERSION}
rm -rf bin

echo "Done."