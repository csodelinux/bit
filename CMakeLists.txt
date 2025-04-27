cmake_minimum_required(VERSION 4.0)
project(bit)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

file(GLOB SOURCES "src/*.cpp")
add_executable(bit ${SOURCES})

target_include_directories(bit PRIVATE includes)
target_compile_options(bit PRIVATE -Wall -Wextra -Wpedantic)

