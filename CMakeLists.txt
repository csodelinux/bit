cmake_minimum_required(VERSION 3.10)
project(bit VERSION 1.0)

# Build options
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Option for system-wide installation (off by default)
option(SYSTEM_WIDE_INSTALL "Install system-wide" OFF)

# Source files
file(GLOB SOURCES "src/*.cpp")
add_executable(bit ${SOURCES})
target_include_directories(bit PRIVATE includes)

# Installation configuration
include(GNUInstallDirs)

# Set installation paths based on the installation type
if(SYSTEM_WIDE_INSTALL)
    # System-wide installation (typically /usr/local/bin)
    set(CMAKE_INSTALL_PREFIX "/usr/local" CACHE PATH "Installation prefix" FORCE)
    message(STATUS "Configured for system-wide installation to ${CMAKE_INSTALL_PREFIX}")
else()
    # Default to user's home directory if not specified
    if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
        set(CMAKE_INSTALL_PREFIX "$ENV{HOME}/.local" CACHE PATH "Installation prefix" FORCE)
    endif()
    message(STATUS "Configured for local installation to ${CMAKE_INSTALL_PREFIX}")
endif()

# Installation targets
install(TARGETS bit 
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
        PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

# Install header files if needed
install(DIRECTORY includes/ 
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/bit
        FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp")

# Common ignore patterns for source packages
set(COMMON_SOURCE_IGNORE_FILES
    "/\\\\.git/"
    "${CMAKE_BINARY_DIR}"
    "build/"
    "/\\\\.vscode/"
    "/\\\\.vs/"
    "/\\\\.clangd/"
    "/\\\\.cache/"
    "compile_commands\\\\.json"
    "\\\\.clang-format"
    "\\\\.clang-tidy"
    "/\\\\.cmake/"
    "\\\\.gitignore"
    "\\\\.DS_Store"
    "CMakeFiles/"
    "bin/"
    "scripts/"
    "test/"
    "website/"
    "bit.iss"
    "install.sh"
    "Makefile"
    "CMakeCache\\\\.txt"
    "\\\\.user"
    "\\\\.suo"
    "\\\\.sdf"
    "\\\\.opensdf"
    "\\\\.exe"
    "_CPack_Packages/"
)

# Set package version
set(CPACK_PACKAGE_VERSION ${PROJECT_VERSION})
set(CPACK_PACKAGE_NAME ${PROJECT_NAME})

# Platform-specific packaging
if(UNIX AND NOT APPLE)
    # Linux packaging
    set(CPACK_GENERATOR "TGZ" CACHE STRING "Linux generators")
    set(CPACK_SOURCE_GENERATOR "TGZ" CACHE STRING "Linux source generators")
    set(CPACK_SOURCE_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-Source")
    set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-linux")
    
    message(STATUS "Linux build: Packaging will create tar archives for binary and source")
elseif(WIN32)
    # Windows build with ZIP packaging only
    set(CPACK_GENERATOR "ZIP" CACHE STRING "Windows generators")
    set(CPACK_SOURCE_GENERATOR "ZIP" CACHE STRING "Windows source generators")
    set(CPACK_SOURCE_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-Source")
    set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-windows")
    
    message(STATUS "Windows build: Standard build with ZIP packages for binary and source")
endif()

# Setting source ignore files
set(CPACK_SOURCE_IGNORE_FILES ${COMMON_SOURCE_IGNORE_FILES})

# Include CPack AFTER setting all variables
include(CPack)
