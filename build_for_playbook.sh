#!/bin/bash

BOOST_ROOT=/home/asimonov/Redman/boost-root
SDL_PROJECT=/tmp/SDL
PROJECT_ROOT=/home/asimonov/dev/Purpleman
SDLIMAGE_PROJECT=${PROJECT_ROOT}/SDL_image
SDLMIXER_PROJECT=${PROJECT_ROOT}/SDL_mixer
SDLNET_PROJECT=${PROJECT_ROOT}/SDL_net
SDLTTF_PROJECT=${PROJECT_ROOT}/SDL_ttf

if [ -z "$WESNOTH_ROOT" ]; then
	WESNOTH_ROOT=.
fi

if [ ! -d "build" ]; then
	mkdir -p build
fi

if [ "$1" != "debug" ]; then
	BUILD_TYPE=Release
else
	BUILD_TYPE=Debug
fi
echo "Build type: ${BUILD_TYPE}"

pushd build
PKG_CONFIG_PATH=/home/asimonov/Redman/install/lib/pkgconfig \
PKG_CONFIG_LIBDIR=/home/asimonov/Redman/install/lib/pkgconfig \
cmake \
-DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
-DQNX=ON \
-DCMAKE_SYSTEM_NAME=QNX \
-DCMAKE_C_COMPILER="${QNX_HOST}/usr/bin/qcc" \
-DCMAKE_CXX_COMPILER="${QNX_HOST}/usr/bin/QCC" \
-DTHREADS_PTHREAD_ARG="" \
-DBoost_NO_SYSTEM_PATHS=ON \
-DBOOST_ROOT="${BOOST_ROOT}" \
-DBOOST_INCLUDEDIR="${BOOST_ROOT}/include" \
-DBOOST_LIBRARYDIR="${BOOST_ROOT}/lib" \
-DBoost_IOSTREAMS_LIBRARY="${BOOST_ROOT}/lib/libboost_iostreams.so;${QNX_TARGET}/armle-v7/usr/lib/libz.so" \
-DLIBINTL_INCLUDE_DIR="${QNX_TARGET}/usr/include" \
-DLIBINTL_LIB_FOUND=TRUE \
-DLIBINTL_LIBRARIES="${QNX_TARGET}/armle-v7/usr/lib/libintl.so" \
-DLIBINTL_LIBC_HAS_DGETTEXT=FALSE \
-DSDL_INCLUDE_DIR="${SDL_PROJECT}/include" \
-DSDL_LIBRARY="${SDL_PROJECT}/Device-Debug/libSDL12.so;${PROJECT_ROOT}/TouchControlOverlay/Device-Debug/libTouchControlOverlay.so" \
-DSDL_FOUND=ON \
-DSDLIMAGE_INCLUDE_DIR="${SDLIMAGE_PROJECT}" \
-DSDLIMAGE_LIBRARY="${SDLIMAGE_PROJECT}/Device-Debug/libSDL_image.so" \
-DSDLIMAGE_FOUND=ON \
-DSDLMIXER_INCLUDE_DIR="${SDLMIXER_PROJECT}" \
-DSDLMIXER_LIBRARY="${SDLMIXER_PROJECT}/Device-Debug/libSDL_mixer.so;${PROJECT_ROOT}/ogg/Device-Debug/libogg.so;${PROJECT_ROOT}/vorbis/Device-Debug/libvorbis.so" \
-DSDLMIXER_FOUND=ON \
-DSDLNET_INCLUDE_DIR="${SDLNET_PROJECT}" \
-DSDLNET_LIBRARY="${SDLNET_PROJECT}/Device-Debug/libSDL_net.so;${QNX_TARGET}/armle-v7/lib/libsocket.so" \
-DSDLNET_FOUND=ON \
-DSDLTTF_INCLUDE_DIR="${SDLTTF_PROJECT}" \
-DSDLTTF_LIBRARY="${SDLTTF_PROJECT}/Device-Debug/libSDL_ttf.so" \
-DSDLTTF_FOUND=ON \
${WESNOTH_ROOT}

make -j8

popd
