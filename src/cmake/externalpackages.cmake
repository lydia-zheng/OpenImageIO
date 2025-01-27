# Copyright Contributors to the OpenImageIO project.
# SPDX-License-Identifier: Apache-2.0
# https://github.com/AcademySoftwareFoundation/OpenImageIO

###########################################################################
# Find external dependencies
###########################################################################

if (NOT VERBOSE)
    set (PkgConfig_FIND_QUIETLY true)
    set (Threads_FIND_QUIETLY true)
endif ()

message (STATUS "${ColorBoldWhite}")
message (STATUS "* Checking for dependencies...")
message (STATUS "*   - Missing a dependency 'Package'?")
message (STATUS "*     Try cmake -DPackage_ROOT=path or set environment var Package_ROOT=path")
message (STATUS "*     For many dependencies, we supply src/build-scripts/build_Package.bash")
message (STATUS "*   - To exclude an optional dependency (even if found),")
message (STATUS "*     -DUSE_Package=OFF or set environment var USE_Package=OFF ")
message (STATUS "${ColorReset}")


set (OIIO_LOCAL_DEPS_PATH "${CMAKE_SOURCE_DIR}/ext/dist" CACHE STRING
     "Local area for dependencies added to CMAKE_PREFIX_PATH")
list (APPEND CMAKE_PREFIX_PATH ${OIIO_LOCAL_DEPS_PATH})

# Tell CMake that find_package should try to find the highest matching version
# of a package, rather than the first one it finds.
set(CMAKE_FIND_PACKAGE_SORT_ORDER NATURAL)


include (FindThreads)


###########################################################################
<<<<<<< HEAD
=======
# Boost setup
if (MSVC)
    # Disable automatic linking using pragma comment(lib,...) of boost libraries upon including of a header
    add_compile_definitions (BOOST_ALL_NO_LIB=1)
endif ()

# If the build system hasn't been specifically told how to link Boost, link it the same way as other
# OIIO dependencies:
if (NOT DEFINED Boost_USE_STATIC_LIBS)
    set (Boost_USE_STATIC_LIBS "${LINKSTATIC}")
endif ()

if (MSVC)
    # Not linking Boost as static libraries: either an explicit setting or LINKSTATIC is FALSE:
    if (NOT Boost_USE_STATIC_LIBS)
        add_compile_definitions (BOOST_ALL_DYN_LINK=1)
    endif ()
endif ()

set (Boost_COMPONENTS thread)
if (NOT USE_STD_FILESYSTEM)
    list (APPEND Boost_COMPONENTS filesystem)
endif ()
message (STATUS "Boost_COMPONENTS = ${Boost_COMPONENTS}")
# The FindBoost.cmake interface is broken if it uses boost's installed
# cmake output (e.g. boost 1.70.0, cmake <= 3.14). Specifically it fails
# to set the expected variables printed below. So until that's fixed
# force FindBoost.cmake to use the original brute force path.
if (NOT DEFINED Boost_NO_BOOST_CMAKE)
    set (Boost_NO_BOOST_CMAKE ON)
endif ()

checked_find_package (Boost REQUIRED
                      VERSION_MIN 1.53
                      COMPONENTS ${Boost_COMPONENTS}
                      RECOMMEND_MIN 1.66
                      RECOMMEND_MIN_REASON "Boost 1.66 is the oldest version our CI tests against"
                      PRINT Boost_INCLUDE_DIRS Boost_LIBRARIES )

# On Linux, Boost 1.55 and higher seems to need to link against -lrt
if (CMAKE_SYSTEM_NAME MATCHES "Linux"
      AND ${Boost_VERSION} VERSION_GREATER_EQUAL 105500)
    list (APPEND Boost_LIBRARIES "rt")
endif ()

include_directories (SYSTEM "${Boost_INCLUDE_DIRS}")
link_directories ("${Boost_LIBRARY_DIRS}")

# end Boost setup
###########################################################################


###########################################################################
>>>>>>> fab3dc2a91d1f73bcae55625262a3e100d32586a
# Dependencies for required formats and features. These are so critical
# that we will not complete the build if they are not found.

checked_find_package (ZLIB REQUIRED)  # Needed by several packages

# Help set up this target for libtiff config file when using static libtiff
if (NOT TARGET CMath::CMath)
    find_library (MATH_LIBRARY m)
    if (NOT MATH_LIBRARY-NOTFOUND)
        add_library (CMath::CMath UNKNOWN IMPORTED)
        set_property (TARGET CMath::CMath
                      APPEND PROPERTY IMPORTED_LOCATION  ${MATH_LIBRARY})
    endif ()
endif ()
<<<<<<< HEAD
=======

checked_find_package (TIFF REQUIRED
                      VERSION_MIN 3.9
                      RECOMMEND_MIN 4.0
                      RECOMMEND_MIN_REASON "to support >4GB files")
>>>>>>> fab3dc2a91d1f73bcae55625262a3e100d32586a

# IlmBase & OpenEXR
checked_find_package (Imath REQUIRED
    VERSION_MIN 3.1
    PRINT IMATH_INCLUDES OPENEXR_INCLUDES Imath_VERSION
)

checked_find_package (OpenEXR REQUIRED
    VERSION_MIN 3.1
    NO_FP_RANGE_CHECK
    PRINT IMATH_INCLUDES OPENEXR_INCLUDES Imath_VERSION
    )

# Force Imath includes to be before everything else to ensure that we have
# the right Imath/OpenEXR version, not some older version in the system
# library.
include_directories(BEFORE ${IMATH_INCLUDES} ${OPENEXR_INCLUDES})
<<<<<<< HEAD
set (OPENIMAGEIO_IMATH_TARGETS Imath::Imath)
set (OPENIMAGEIO_OPENEXR_TARGETS OpenEXR::OpenEXR)
set (OPENIMAGEIO_IMATH_DEPENDENCY_VISIBILITY "PRIVATE" CACHE STRING
=======
if (MSVC AND NOT LINKSTATIC)
    add_compile_definitions (OPENEXR_DLL) # Is this needed for new versions?
endif ()
if (OpenEXR_VERSION VERSION_GREATER_EQUAL 3.0)
    set (OIIO_USING_IMATH 3)
else ()
    set (OIIO_USING_IMATH 2)
endif ()
set (OPENIMAGEIO_IMATH_TARGETS
            # For OpenEXR/Imath 3.x:
            $<TARGET_NAME_IF_EXISTS:Imath::Imath>
            $<TARGET_NAME_IF_EXISTS:Imath::Half>
            # For OpenEXR >= 2.4/2.5 with reliable exported targets
            $<TARGET_NAME_IF_EXISTS:IlmBase::Imath>
            $<TARGET_NAME_IF_EXISTS:IlmBase::Half>
            $<TARGET_NAME_IF_EXISTS:IlmBase::Iex> )
set (OPENIMAGEIO_OPENEXR_TARGETS
            # For OpenEXR/Imath 3.x:
            $<TARGET_NAME_IF_EXISTS:OpenEXR::OpenEXR>
            # For OpenEXR >= 2.4/2.5 with reliable exported targets
            $<TARGET_NAME_IF_EXISTS:OpenEXR::IlmImf>
            $<TARGET_NAME_IF_EXISTS:IlmBase::IlmThread>
            $<TARGET_NAME_IF_EXISTS:IlmBase::Iex> )
set (OPENIMAGEIO_IMATH_DEPENDENCY_VISIBILITY "PUBLIC" CACHE STRING
>>>>>>> fab3dc2a91d1f73bcae55625262a3e100d32586a
     "Should we expose Imath library dependency as PUBLIC or PRIVATE")
set (OPENIMAGEIO_CONFIG_DO_NOT_FIND_IMATH OFF CACHE BOOL
     "Exclude find_dependency(Imath) from the exported OpenImageIOConfig.cmake")

# JPEG -- prefer JPEG-Turbo to regular libjpeg
checked_find_package (libjpeg-turbo
                      VERSION_MIN 2.1
                      DEFINITIONS USE_JPEG_TURBO=1)
<<<<<<< HEAD
if (TARGET libjpeg-turbo::jpeg) # Try to find the non-turbo version
    # Doctor it so libjpeg-turbo is aliased as JPEG::JPEG
    alias_library_if_not_exists (JPEG::JPEG libjpeg-turbo::jpeg)
    set (JPEG_FOUND TRUE)
else ()
    # Try to find the non-turbo version
=======
if (NOT TARGET libjpeg-turbo::jpeg) # Try to find the non-turbo version
>>>>>>> fab3dc2a91d1f73bcae55625262a3e100d32586a
    checked_find_package (JPEG REQUIRED)
endif ()


# Ultra HDR
checked_find_package (libuhdr)


checked_find_package (TIFF REQUIRED
                      VERSION_MIN 4.0)
alias_library_if_not_exists (TIFF::TIFF TIFF::tiff)

# JPEG XL
option (USE_JXL "Enable JPEG XL support" ON)
checked_find_package (JXL
                      VERSION_MIN 0.10.1
                      DEFINITIONS USE_JXL=1)

# Pugixml setup.  Normally we just use the version bundled with oiio, but
# some linux distros are quite particular about having separate packages so we
# allow this to be overridden to use the distro-provided package if desired.
option (USE_EXTERNAL_PUGIXML "Use an externally built shared library version of the pugixml library" OFF)
if (USE_EXTERNAL_PUGIXML)
    checked_find_package (pugixml REQUIRED
                          VERSION_MIN 1.8
                          DEFINITIONS USE_EXTERNAL_PUGIXML=1)
else ()
    message (STATUS "Using internal PugiXML")
endif()

# From pythonutils.cmake
find_python()
if (USE_PYTHON)
    checked_find_package (pybind11 REQUIRED VERSION_MIN 2.7)
endif ()


###########################################################################
# Dependencies for optional formats and features. If these are not found,
# we will continue building, but the related functionality will be disabled.

checked_find_package (PNG VERSION_MIN 1.6.0)
if (TARGET PNG::png_static)
    set (PNG_TARGET PNG::png_static)
elseif (TARGET PNG::PNG)
    set (PNG_TARGET PNG::PNG)
endif ()

checked_find_package (Freetype
<<<<<<< HEAD
                      VERSION_MIN 2.10.0
                      DEFINITIONS USE_FREETYPE=1 )

checked_find_package (OpenColorIO REQUIRED
                      VERSION_MIN 2.2
                      VERSION_MAX 2.9
                     )
if (NOT OPENCOLORIO_INCLUDES)
    get_target_property(OPENCOLORIO_INCLUDES OpenColorIO::OpenColorIO INTERFACE_INCLUDE_DIRECTORIES)
=======
                   DEFINITIONS USE_FREETYPE=1 )

checked_find_package (OpenColorIO
                      DEFINITIONS  USE_OCIO=1 USE_OPENCOLORIO=1
                      # PREFER_CONFIG
                      )
if (OpenColorIO_FOUND)
    option (OIIO_DISABLE_BUILTIN_OCIO_CONFIGS
           "For deveoper debugging/testing ONLY! Disable OCIO 2.2 builtin configs." OFF)
    if (OIIO_DISABLE_BUILTIN_OCIO_CONFIGS OR "$ENV{OIIO_DISABLE_BUILTIN_OCIO_CONFIGS}")
        add_compile_definitions(OIIO_DISABLE_BUILTIN_OCIO_CONFIGS)
    endif ()
else ()
    set (OpenColorIO_FOUND 0)
>>>>>>> fab3dc2a91d1f73bcae55625262a3e100d32586a
endif ()
include_directories(BEFORE ${OPENCOLORIO_INCLUDES})

<<<<<<< HEAD
checked_find_package (OpenCV 4.0
=======
checked_find_package (OpenCV 3.0
>>>>>>> fab3dc2a91d1f73bcae55625262a3e100d32586a
                      DEFINITIONS USE_OPENCV=1)

# Intel TBB
set (TBB_USE_DEBUG_BUILD OFF)
checked_find_package (TBB 2017
                      SETVARIABLES OIIO_TBB
                      PREFER_CONFIG)

# DCMTK is used to read DICOM images
checked_find_package (DCMTK CONFIG VERSION_MIN 3.6.1)

checked_find_package (FFmpeg VERSION_MIN 4.0)

checked_find_package (GIF VERSION_MIN 5.0)

# For HEIF/HEIC/AVIF formats
checked_find_package (Libheif VERSION_MIN 1.11
                      RECOMMEND_MIN 1.16
                      RECOMMEND_MIN_REASON "for orientation support")

checked_find_package (LibRaw
                      VERSION_MIN 0.20.0
                      PRINT LibRaw_r_LIBRARIES)

checked_find_package (OpenJPEG VERSION_MIN 2.0
                      RECOMMEND_MIN 2.2
                      RECOMMEND_MIN_REASON "for multithreading support")
# Note: Recent OpenJPEG versions have exported cmake configs, but we don't
# find them reliable at all, so we stick to our FindOpenJPEG.cmake module.

checked_find_package (OpenVDB
                      VERSION_MIN  9.0
                      DEPS         TBB
                      DEFINITIONS  USE_OPENVDB=1)
<<<<<<< HEAD
=======
if (OpenVDB_FOUND AND OpenVDB_VERSION VERSION_GREATER_EQUAL 10.1 AND CMAKE_CXX_STANDARD VERSION_LESS 17)
    message (WARNING "${ColorYellow}OpenVDB >= 10.1 (we found ${OpenVDB_VERSION}) can only be used when we build with C++17 or higher. Disabling OpenVDB support.${ColorReset}")
    set (OpenVDB_FOUND 0)
    add_compile_definitions(DISABLE_OPENVDB=1)
endif ()
>>>>>>> fab3dc2a91d1f73bcae55625262a3e100d32586a

checked_find_package (Ptex PREFER_CONFIG)
if (NOT Ptex_FOUND OR NOT Ptex_VERSION)
    # Fallback for inadequate Ptex exported configs. This will eventually
    # disappear when we can 100% trust Ptex's exports.
    unset (Ptex_FOUND)
    checked_find_package (Ptex)
endif ()

checked_find_package (WebP VERSION_MIN 1.1)

option (USE_R3DSDK "Enable R3DSDK (RED camera) support" OFF)
checked_find_package (R3DSDK NO_RECORD_NOTFOUND)  # RED camera

set (NUKE_VERSION "7.0" CACHE STRING "Nuke version to target")
checked_find_package (Nuke NO_RECORD_NOTFOUND)

if (FFmpeg_FOUND OR FREETYPE_FOUND)
    checked_find_package (BZip2)   # Used by ffmpeg and freetype
    if (NOT BZIP2_FOUND)
        set (BZIP2_LIBRARIES "")  # TODO: why does it break without this?
    endif ()
endif()


# Qt -- used for iv
option (USE_QT "Use Qt if found" ON)
if (USE_QT)
    checked_find_package (OpenGL)   # used for iv
endif ()
if (USE_QT AND OPENGL_FOUND)
    checked_find_package (Qt6 COMPONENTS Core Gui Widgets OpenGLWidgets)
    if (NOT Qt6_FOUND)
        checked_find_package (Qt5 COMPONENTS Core Gui Widgets OpenGL)
    endif ()
    if (NOT Qt5_FOUND AND NOT Qt6_FOUND AND APPLE)
        message (STATUS "  If you think you installed qt with Homebrew and it still doesn't work,")
        message (STATUS "  try:   export PATH=/usr/local/opt/qt/bin:$PATH")
    endif ()
endif ()


# Tessil/robin-map
checked_find_package (Robinmap REQUIRED
                      VERSION_MIN 1.2.0
                      BUILD_LOCAL missing
                     )

# fmtlib
option (OIIO_INTERNALIZE_FMT "Copy fmt headers into <install>/include/OpenImageIO/detail/fmt" ON)
checked_find_package (fmt REQUIRED
                      VERSION_MIN 7.0
                      BUILD_LOCAL missing
                     )
get_target_property(FMT_INCLUDE_DIR fmt::fmt-header-only INTERFACE_INCLUDE_DIRECTORIES)


###########################################################################

list (SORT CFP_ALL_BUILD_DEPS_FOUND COMPARE STRING CASE INSENSITIVE)
message (STATUS "All build dependencies: ${CFP_ALL_BUILD_DEPS_FOUND}")
