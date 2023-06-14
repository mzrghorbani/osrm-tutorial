cmake_minimum_required(VERSION 3.0)

project(check_installations)

message("Checking OSRM required installations on your system")

message("Check for Boost")
find_package(Boost REQUIRED COMPONENTS system iostreams)
if(Boost_FOUND)
    message(STATUS "Boost found: ${Boost_INCLUDE_DIRS}")
else()
    message(FATAL_ERROR "Boost not found. Please install libboost-all-dev.")
endif()

message("Check for TBB")
find_package(TBB REQUIRED)
if(TBB_FOUND)
    message(STATUS "TBB found: ${TBB_INCLUDE_DIRS}")
else()
    message(FATAL_ERROR "TBB not found. Please install libtbb-dev.")
endif()

message("Check for Lua")
find_package(Lua 5.2 REQUIRED)
if(LUA_FOUND)
    message(STATUS "Lua found: ${LUA_INCLUDE_DIR}")
else()
    message(FATAL_ERROR "Lua not found. Please install lua5.2 and liblua5.2-dev.")
endif()

message("Check for Doxygen")
find_package(Doxygen)
if(DOXYGEN_FOUND)
    message(STATUS "Doxygen found: ${DOXYGEN_EXECUTABLE}")
else()
    message(FATAL_ERROR "Doxygen not found. Please install doxygen.")
endif()

message("Installation test completed. Please check for errors!")
