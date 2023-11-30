cmake_minimum_required(VERSION 3.27)

# set(CMAKE_FIND_DEBUG_MODE 1)
set(PROJECT_NAME "playground")
project(${PROJECT_NAME} C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O0 -pedantic -Wall -Wextra -g")
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O2")

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(SOURCES src/main.m)

set(BASE_DIR ${CMAKE_CURRENT_LIST_DIR}/../3rdparty/base/)
set(BASE_LIB_DIR ${BASE_DIR}lib/)
set(BASE_INC_DIR ${BASE_DIR}include/)

set(OSNOVA_DIR ${PROJECT_SOURCE_DIR}/..)
find_library(OSNOVA
    NAMES osnova libosnova
    PATHS ${OSNOVA_DIR}/lib
    NO_DEFAULT_PATH
)

message(STATUS "OSNOVA: [${OSNOVA}]")

if(NOT OSNOVA)
    message(FATAL_ERROR "Library 'osnova' not found. Please compile it first.")
endif()

# add_subdirectory("${CMAKE_SOURCE_DIR}/..")
add_executable(${PROJECT_NAME}
    ${SOURCES}
)

link_directories(${BASE_LIB_DIR})

set_target_properties(${PROJECT_NAME}
    PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/bin"
)

target_include_directories(${PROJECT_NAME}
    PUBLIC
    ${OSNOVA_DIR}/src
    ${BASE_INC_DIR}
)

target_link_libraries(${PROJECT_NAME}
    PUBLIC
    osnova
    base
)
