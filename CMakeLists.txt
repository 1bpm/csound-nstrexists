project("csound_nstrexists")

cmake_minimum_required(VERSION 3.8)

set(APIVERSION "6.0")

# Release or Debug
set(CMAKE_BUILD_TYPE "Release")

# force make to print the command lines
set(CMAKE_VERBOSE_MAKEFILE on)

# path to Csound cmake module
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")

# set compilation flags
set(CMAKE_C_FLAGS  ${CMAKE_C_FLAGS}  "-fpermissive -fPIC -w -DUSE_DOUBLE -DB64BIT")

# options
option(USE_LIB64 "Set to on to set installation dir for libs to lib64" OFF)
option(USE_DOUBLE "Use doubles for audio calculations" ON)

set(BUILDING_CSOUND_PLUGINS ON)

# ----------------------------------------------

include(FindCsound)

include(CheckCCompilerFlag)

# -----------------------------------------------

function(addflag flag flagname)
  check_c_compiler_flag(${flag} ${flagname})
  if (${flagname})
    # message(STATUS "Setting C flag ${flag}")    
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${flag}" PARENT_SCOPE)
  endif()
endfunction(addflag)


MACRO(SUBDIRLIST result curdir)
  FILE(GLOB children RELATIVE ${curdir} ${curdir}/*)
  SET(dirlist "")
  FOREACH(child ${children})
    message(STATUS "looking at ${child}")
    IF(IS_DIRECTORY ${curdir}/${child})
        LIST(APPEND dirlist ${child})
    ENDIF()
  ENDFOREACH()
  SET(${result} ${dirlist})
ENDMACRO()

  
MACRO(ADD_ALL_SUBDIRECTORIES directory)
  subdirlist(SUBDIRS ${directory})
  message(STATUS "Found subdirs: ${SUBDIRS}")
  foreach(SUBDIR ${SUBDIRS})
    set(thissubdir "${directory}/${SUBDIR}")
    if(EXISTS "${directory}/${SUBDIR}/CMakeLists.txt")
      message(STATUS "Adding subdir: ${thissubdir}")
      add_subdirectory(${directory}/${SUBDIR})
    else()
      message(WARNING "Skipping ${directory}/${SUBDIR} because no CMakeLists.txt file was found")
    endif()
  endforeach()
ENDMACRO()



# set optimization flags
if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_COMPILER_IS_CLANG)
  add_definitions(-fvisibility=hidden)
  if(NATIVE)
	add_definitions(-march=native)
  endif()
  
  include(CheckCCompilerFlag)
  include(CheckCXXCompilerFlag)

  addflag(-msse HAS_SSE)
  addflag(-msse2 HAS_SSE2)
  addflag(-mfgpath=sse HAS_FPMATH_SSE)
  
endif()

if(MINGW)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mstackrealign")
endif()

addflag(-ftree-vectorize HAS_TREE_VECTORIZE)
addflag(-ffast-math HAS_FAST_MATH)
addflag(-fomit-frame-pointer HAS_OMIT_FRAME_POINTER)


# -------------------------------------------------------------------

set(CS_FRAMEWORK_DEST "~/Library/Frameworks")


if(USE_LIB64)
  set(LIBRARY_INSTALL_DIR "lib64")
  add_definitions("-DLIB64")
else()
  set(LIBRARY_INSTALL_DIR "lib")
endif()

message(STATUS "LIBRARY INSTALL DIR: ${LIBRARY_INSTALL_DIR}")

# -------------------------------------------------------------------


if(USE_DOUBLE)
  message(STATUS ">>> using doubles")
  
  if(APPLE)
    set(CSOUNDLIB "CsoundLib64")
    set(PLUGIN_INSTALL_DIR "${CS_FRAMEWORK_DEST}/${CSOUNDLIB}.framework/Versions/${APIVERSION}/Resources/Opcodes64")
  else()
    set(CSOUNDLIB "csound64")
    set(PLUGIN_INSTALL_DIR "${LIBRARY_INSTALL_DIR}/csound/plugins64-${APIVERSION}")
  endif()
else()
  message(STATUS ">>> not using doubles")
  if(APPLE)
    set(CSOUNDLIB "CsoundLib")
    set(PLUGIN_INSTALL_DIR "${CS_FRAMEWORK_DEST}/${CSOUNDLIB}.framework/Versions/${APIVERSION}/Resources/Opcodes")
  else()
    set(CSOUNDLIB "csound")
    set(PLUGIN_INSTALL_DIR "${LIBRARY_INSTALL_DIR}/csound/plugins-${APIVERSION}")
  endif()
endif()


# -------------------------------------------------------------------
  
# Csound opcode build
find_package(Csound)


set(BUILD_PLUGINS_DIR ${CMAKE_CURRENT_BINARY_DIR})

if(NOT CSOUND_FOUND)
  message(FATAL_ERROR "Csound installation not found")
endif()

set(CFILES src/opcodes.c)

include_directories(${CSOUND_INCLUDE_DIRS})
include_directories(include)


add_library(nstrexists SHARED ${CFILES})

set_target_properties(nstrexists PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${BUILD_PLUGINS_DIR}
  LIBRARY_OUTPUT_DIRECTORY ${BUILD_PLUGINS_DIR})
 
install(TARGETS nstrexists LIBRARY DESTINATION "${PLUGIN_INSTALL_DIR}" )

