cmake_minimum_required(VERSION 4.0)
project(bit)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

file(GLOB SOURCES "src/*.cpp")
add_executable(bit ${SOURCES})
target_include_directories(bit PRIVATE includes)

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
set(CPACK_PACKAGE_VERSION "1.0")

# Platform-specific packaging
if(UNIX AND NOT APPLE)
    # Linux packaging
    set(CPACK_GENERATOR "TGZ" CACHE STRING "Linux generators")
    set(CPACK_SOURCE_GENERATOR "TGZ" CACHE STRING "Linux source generators")
    set(CPACK_PACKAGE_NAME "bit")
    set(CPACK_SOURCE_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-Source")
    set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-linux")
    
    # Create binary package
    install(TARGETS bit DESTINATION bin)
    
    message(STATUS "Linux build: Packaging will create tar archives for binary and source")
elseif(WIN32)
    # Windows build with ZIP packaging only
    set(CPACK_GENERATOR "ZIP" CACHE STRING "Windows generators")
    set(CPACK_SOURCE_GENERATOR "ZIP" CACHE STRING "Windows source generators")
    set(CPACK_PACKAGE_NAME "bit")
    set(CPACK_SOURCE_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-Source")
    set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-windows")
    
    # Create binary package
    install(TARGETS bit DESTINATION bin)
    
    message(STATUS "Windows build: Standard build with ZIP packages for binary and source")
endif()

# Setting source ignore files
set(CPACK_SOURCE_IGNORE_FILES ${COMMON_SOURCE_IGNORE_FILES})

# Include CPack AFTER setting all variables
include(CPack)
