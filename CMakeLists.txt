cmake_minimum_required (VERSION 2.6)
project (discount C)

# Needed on UNIX
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

if(WIN32)
  find_package (Lua REQUIRED)
else()
  # Only the include dir matters on UNIX
  find_package (Lua)
  if(NOT LUA_INCLUDE_DIR)
    message( FATAL_ERROR "Variable `LUA_INCLUDE_DIR' expected to be defined.")
  endif()
endif()
include_directories(${LUA_INCLUDE_DIR})

# discount
add_subdirectory(${PROJECT_SOURCE_DIR}/discount/cmake)
include_directories(${PROJECT_SOURCE_DIR}/discount)

# lua-discount
add_library( discount MODULE discount.c )
set_target_properties( discount PROPERTIES PREFIX "" )
target_link_libraries ( discount libmarkdown )

# Only link against the Lua library on Windows
if(WIN32)
  target_link_libraries ( discount ${LUA_LIBRARIES} )
endif()

# Needed to avoid getting undefined references to liblua
if(APPLE)
  set(CMAKE_SHARED_MODULE_CREATE_C_FLAGS "${CMAKE_SHARED_MODULE_CREATE_C_FLAGS} -undefined dynamic_lookup")
endif()

# Build static library when cross-compiling
if(WIN32 AND CMAKE_HOST_UNIX)
  add_library( libdiscount STATIC discount.c )
  target_link_libraries ( libdiscount ${LUA_LIBRARIES} libmarkdown )
  set_target_properties ( libdiscount PROPERTIES OUTPUT_NAME discount )
endif()

# Install targets for Luarocks and non-Luarocks
if(LUAROCKS_INSTALL_LIBDIR)
  SET(INSTALL_LIB_DIR ${LUAROCKS_INSTALL_LIBDIR})
elseif(UNIX)
  set(INSTALL_LIB_DIR "${CMAKE_INSTALL_PREFIX}/lib/lua/${LUA_VERSION_MAJOR}.${LUA_VERSION_MINOR}")
elseif(WIN32)
  set(INSTALL_LIB_DIR "${PROJECT_SOURCE_DIR}")
endif()

if(INSTALL_LIB_DIR)
  install(TARGETS discount ARCHIVE DESTINATION "${INSTALL_LIB_DIR}" LIBRARY DESTINATION "${INSTALL_LIB_DIR}")
endif()