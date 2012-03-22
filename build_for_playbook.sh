#!/bin/bash

#BOOST_ROOT=/home/asimonov/Redman/boost-root
#SDL_PROJECT=/tmp/SDL
#PROJECT_ROOT=/home/asimonov/dev/Purpleman
#SDLIMAGE_PROJECT=${PROJECT_ROOT}/SDL_image
#SDLMIXER_PROJECT=${PROJECT_ROOT}/SDL_mixer
#SDLNET_PROJECT=${PROJECT_ROOT}/SDL_net
#SDLTTF_PROJECT=${PROJECT_ROOT}/SDL_ttf

BUILD_TYPE=Release
if [ -z "$WESNOTH_ROOT" ]; then
  WESNOTH_ROOT=$(PWD)
fi
if [ -z "$PROJECT_ROOT" ]; then
  PROJECT_ROOT=$(PWD)/..
fi
PKG_CONFIG_PATH=$(PWD)/../install/lib/pkgconfig
PKG_CONFIG_LIBDIR=$(PWD)/../install/lib/pkgconfig
while true; do
  case "$1" in
    -h | --help ) 
        echo "Build script for BlackBerry PlayBook"
        echo "For normal usage, please use the NDK to build."
        echo
        echo "Options: "
        echo "  -d, --debug             Create a debug build. (default is release)"
	echo "  -h, --help              Show this help message."
	echo "  -r, --root PATH         Specify the root directory of Wesnoth. (default is PWD)"
        echo "  -p, --project-root PATH Specify the root directory containing all projects. (default is PWD/..)"
        echo "                          If specific projects are in different directories, you can specify them below."
        echo "  --pkg-config PATH       Specify the pkgconfig directory. (default is PWD/../install/lib/pkgconfig)"
        echo
        echo "Dependency Paths (defaults are under project root): "
        echo "  --sdl PATH                   SDL 1.2 project directory (default is SDL)"
        echo "  --tco PATH                   TouchControlOverlay project directory (default is TouchControlOverlay)"
        echo "  --sdl_image PATH             SDL_image project directory (default is SDL_image)"
        echo "  --sdl_mixer PATH             SDL_mixer project directory (default is SDL_mixer)"
        echo "  --sdl_net PATH               SDL_net project directory (default is SDL_net)"
        echo "  --sdl_ttf PATH               SDL_ttf project directory (default is SDL_ttf)"
        echo "  --ogg PATH                   ogg project directory (default is ogg)"
        echo "  --vorbis PATH                vorbis project directory (default is vorbis)"
        echo "  --boost_headers PATH         Boost headers project directory (default is boost_headers)"
        echo "  --boost_iostreams PATH       Boost iostreams project directory (default is boost_iostreams)"
        echo "  --boost_regex PATH           Boost regex project directory (default is boost_regex)"
        echo "  --boost_program_options PATH Boost program_options project directory (default is boost_program_options)"
        echo "  --boost_system PATH          Boost system project directory (default is boost_system)"
        exit 0
        ;;
    -d | --debug ) BUILD_TYPE=Debug; shift ;;
    -r | --root ) WESNOTH_ROOT="$2"; shift 2 ;;
    -p | --project-root ) PROJECT_ROOT="$2"; shift 2 ;;
    --pkg-config ) PKG_CONFIG_PATH="$2"; PKG_CONFIG_LIBDIR="$2"; shift 2 ;;
    --sdl ) SDL_PROJECT="$2"; shift 2 ;;
    --sdl_image ) SDLIMAGE_PROJECT="$2"; shift 2 ;;
    --sdl_mixer ) SDLMIXER_PROJECT="$2"; shift 2 ;;
    --sdl_net ) SDLNET_PROJECT="$2"; shift 2 ;;
    --sdl_ttf ) SDLTTF_PROJECT="$2"; shift 2 ;;
    --tco ) TCO_PROJECT="$2"; shift 2 ;;
    --ogg ) OGG_PROJECT="$2"; shift 2 ;;
    --vorbis ) VORBIS_PROJECT="$2"; shift 2 ;;
    --boost_headers ) BOOST_HEADERS="$2"; shift 2 ;;
    --boost_iostreams ) BOOST_IOSTREAMS="$2"; shift 2 ;;
    --boost_regex ) BOOST_REGEX="$2"; shift 2 ;;
    --boost_program_options ) BOOST_PROGRAMOPTIONS="$2"; shift 2 ;;
    --boost_system ) BOOST_SYSTEM="$2"; shift 2 ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

if [ -z "$SDL_PROJECT" ]; then
  SDL_PROJECT="$PROJECT_ROOT/SDL"
fi
if [ -z "$SDLIMAGE_PROJECT" ]; then
  SDLIMAGE_PROJECT="$PROJECT_ROOT/SDL_image"
fi
if [ -z "$SDLMIXER_PROJECT" ]; then
  SDLMIXER_PROJECT="$PROJECT_ROOT/SDL_mixer"
fi
if [ -z "$SDLNET_PROJECT" ]; then
  SDLNET_PROJECT="$PROJECT_ROOT/SDL_net"
fi
if [ -z "$SDLTTF_PROJECT" ]; then
  SDLTTF_PROJECT="$PROJECT_ROOT/SDL_ttf"
fi
if [ -z "$TCO_PROJECT" ]; then
  TCO_PROJECT="$PROJECT_ROOT/TouchControlOverlay"
fi
if [ -z "$OGG_PROJECT" ]; then
  OGG_PROJECT="$PROJECT_ROOT/ogg"
fi
if [ -z "$VORBIS_PROJECT" ]; then
  VORBIS_PROJECT="$PROJECT_ROOT/vorbis"
fi
if [ -z "$BOOST_HEADERS" ]; then
  BOOST_HEADERS="$PROJECT_ROOT/boost_headers"
fi
if [ -z "$BOOST_IOSTREAMS" ]; then
  BOOST_IOSTREAMS="$PROJECT_ROOT/boost_iostreams"
fi
if [ -z "$BOOST_REGEX" ]; then
  BOOST_REGEX="$PROJECT_ROOT/boost_regex"
fi
if [ -z "$BOOST_PROGRAMOPTIONS" ]; then
  BOOST_PROGRAMOPTIONS="$PROJECT_ROOT/boost_program_options"
fi
if [ -z "$BOOST_SYSTEM" ]; then
  BOOST_SYSTEM="$PROJECT_ROOT/boost_system"
fi

export PKG_CONFIG_PATH
export PKG_CONFIG_LIBDIR

# Create shadow build directory
if [ ! -d "build" ]; then
	mkdir -p build
fi

echo "Build type: ${BUILD_TYPE}"

#-DBOOST_ROOT="${BOOST_ROOT}" \
#-DBOOST_LIBRARYDIR="${BOOST_ROOT}/lib" \
#-DBoost_IOSTREAMS_LIBRARY="${BOOST_ROOT}/lib/libboost_iostreams.so;${QNX_TARGET}/armle-v7/usr/lib/libz.so" \

pushd build
cmake \
-DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
-DCMAKE_SYSTEM_NAME=QNX \
-DCMAKE_C_COMPILER="${QNX_HOST}/usr/bin/qcc" \
-DCMAKE_CXX_COMPILER="${QNX_HOST}/usr/bin/QCC" \
-DTHREADS_PTHREAD_ARG="" \
-DBoost_NO_SYSTEM_PATHS=ON \
-DBoost_DEBUG=ON \
-DBOOST_INCLUDEDIR="${BOOST_HEADERS}" \
-D_boost_LIBRARY_SEARCH_DIRS_ALWAYS="${BOOST_IOSTREAMS}/Device-${BUILD_TYPE};${BOOST_REGEX}/Device-${BUILD_TYPE};${BOOST_PROGRAMOPTIONS}/Device-${BUILD_TYPE};${BOOST_SYSTEM}/Device-${BUILD_TYPE}" \
-DBoost_LIBRARY_DIRS="${BOOST_IOSTREAMS}/Device-${BUILD_TYPE};${BOOST_REGEX}/Device-${BUILD_TYPE};${BOOST_PROGRAMOPTIONS}/Device-${BUILD_TYPE};${BOOST_SYSTEM}/Device-${BUILD_TYPE}" \
-DBoost_IOSTREAMS_LIBRARY="${BOOST_IOSTREAMS}/Device-${BUILD_TYPE}/libboost_iostreams.so;${QNX_TARGET}/armle-v7/usr/lib/libz.so" \
-DBoost_REGEX_LIBRARY="${BOOST_REGEX}/Device-${BUILD_TYPE}/libboost_regex.so" \
-DBoost_PROGRAM_OPTIONS_LIBRARY="${BOOST_PROGRAMOPTIONS}/Device-${BUILD_TYPE}/libboost_program_options.so" \
-DBoost_SYSTEM_LIBRARY="${BOOST_SYSTEM}/Device-${BUILD_TYPE}/libboost_system.so" \
-DLIBINTL_INCLUDE_DIR="${QNX_TARGET}/usr/include" \
-DLIBINTL_LIB_FOUND=TRUE \
-DLIBINTL_LIBRARIES="${QNX_TARGET}/armle-v7/usr/lib/libintl.so" \
-DLIBINTL_LIBC_HAS_DGETTEXT=FALSE \
-DSDL_INCLUDE_DIR="${SDL_PROJECT}/include" \
-DSDL_LIBRARY="${SDL_PROJECT}/Device-${BUILD_TYPE}/libSDL12.so;${TCO_PROJECT}/Device-${BUILD_TYPE}/libTouchControlOverlay.so" \
-DSDL_FOUND=ON \
-DSDLIMAGE_INCLUDE_DIR="${SDLIMAGE_PROJECT}" \
-DSDLIMAGE_LIBRARY="${SDLIMAGE_PROJECT}/Device-${BUILD_TYPE}/libSDL_image.so" \
-DSDLIMAGE_FOUND=ON \
-DSDLMIXER_INCLUDE_DIR="${SDLMIXER_PROJECT}" \
-DSDLMIXER_LIBRARY="${SDLMIXER_PROJECT}/Device-${BUILD_TYPE}/libSDL_mixer.so;${OGG_PROJECT}/Device-${BUILD_TYPE}/libogg.so;${VORBIS_PROJECT}/Device-${BUILD_TYPE}/libvorbis.so" \
-DSDLMIXER_FOUND=ON \
-DSDLNET_INCLUDE_DIR="${SDLNET_PROJECT}" \
-DSDLNET_LIBRARY="${SDLNET_PROJECT}/Device-${BUILD_TYPE}/libSDL_net.so;${QNX_TARGET}/armle-v7/lib/libsocket.so" \
-DSDLNET_FOUND=ON \
-DSDLTTF_INCLUDE_DIR="${SDLTTF_PROJECT}" \
-DSDLTTF_LIBRARY="${SDLTTF_PROJECT}/Device-${BUILD_TYPE}/libSDL_ttf.so" \
-DSDLTTF_FOUND=ON \
${WESNOTH_ROOT}

make -j8

popd
