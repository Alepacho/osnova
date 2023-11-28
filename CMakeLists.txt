cmake_minimum_required(VERSION 3.27)

set(LIBRARY_NAME "osnova")
project(${LIBRARY_NAME})
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O0 -pedantic -Wall -Wextra -g")
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O2")

set(BASE_DIR ${CMAKE_CURRENT_LIST_DIR}/3rdparty/base/)
set(BASE_LIB_DIR ${BASE_DIR}lib/)
set(BASE_INC_DIR ${BASE_DIR}include/)

set(SOURCE_DIR "${CMAKE_SOURCE_DIR}/src")
set(SOURCES
    ${SOURCE_DIR}/osnova.m
    ${SOURCE_DIR}/window.m
)

set(HEADERS
    ${SOURCE_DIR}/osnova.h
    ${SOURCE_DIR}/window.h
)

add_library(${LIBRARY_NAME}
    STATIC
    ${HEADERS}
    ${SOURCES}
)

link_directories(${BASE_LIB_DIR})

set_target_properties(${LIBRARY_NAME}
    PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/lib"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/lib"
)

target_include_directories(${LIBRARY_NAME}
    PUBLIC
    ${BASE_INC_DIR}
)

target_link_libraries(${LIBRARY_NAME}
    PUBLIC
    base
    "-framework Cocoa"
    "-framework AppKit"
    "-framework CoreData"
    "-framework Foundation"
)

target_sources(${LIBRARY_NAME} INTERFACE
    ${HEADERS}
    ${SOURCES}
)

add_subdirectory(${CMAKE_SOURCE_DIR}/test)
