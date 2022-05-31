cmake_minimum_required(VERSION 3.20)
project(TestPlugin VERSION 0.0.1 LANGUAGES C CXX ASM)
set(CMAKE_CXX_STANDARD 17)
add_subdirectory(libs/JUCE)
add_subdirectory(libs/clap-juce-extensions EXCLUDE_FROM_ALL)

math(EXPR BITNESS "${CMAKE_SIZEOF_VOID_P} * 8" OUTPUT_FORMAT DECIMAL)
message(STATUS "${PROJECT_NAME} ${BITNESS}-bit, version ${PROJECT_VERSION}, ${CMAKE_BUILD_TYPE} build")
message(STATUS "CMake version ${CMAKE_VERSION}, Compiler version ${CMAKE_CXX_COMPILER_VERSION}")

juce_add_plugin(${PROJECT_NAME}
    PRODUCT_NAME "Test Plugin"
    COMPANY_NAME "Test Company"
    FORMATS VST3 Standalone
    PLUGIN_MANUFACTURER_CODE Manu
    PLUGIN_CODE Plug
    ICON_BIG "${CMAKE_SOURCE_DIR}/resources/images/logo.png"
)

clap_juce_extensions_plugin(
    TARGET ${PROJECT_NAME}
    CLAP_ID "org.test.test"
    CLAP_FEATURES audio_effect
)

target_sources(${PROJECT_NAME}
    PRIVATE
        src/PluginEditor.cpp
        src/PluginProcessor.cpp)

target_compile_definitions(${PROJECT_NAME}
    PUBLIC
        JUCE_WEB_BROWSER=0
        JUCE_USE_CURL=0
        JUCE_VST3_CAN_REPLACE_VST2=0
        JUCE_DISPLAY_SPLASH_SCREEN=0)

if(DEFINED ENV{ASIOSDK_DIR} OR POWERSHELL_ASIO)
    if(POWERSHELL_ASIO)
        execute_process(COMMAND pwsh -NoProfile -Command "& {Import-Module .\\scripts\\ASIO && asio}")
        target_compile_definitions(${PROJECT_NAME} PUBLIC JUCE_ASIO=1)
        target_include_directories(${PROJECT_NAME} PUBLIC libs/asio/common)
    else()
        message(STATUS "Checking for Steinberg ASIO SDK")
        if(EXISTS "$ENV{ASIOSDK_DIR}/readme.txt")
            file(TO_CMAKE_PATH "$ENV{ASIOSDK_DIR}" ASIOSDK_DIR)
            message(STATUS "Steinberg ASIO SDK location: ${ASIOSDK_DIR}")
            message(STATUS "The resulting standalone executables are not licensed for distribution")
            target_compile_definitions(${PROJECT_NAME} PUBLIC JUCE_ASIO=1)
            target_include_directories(${PROJECT_NAME} PUBLIC ${ASIOSDK_DIR}/common)
        else()
            message(STATUS "Steinberg ASIO SDK not found")
        endif()
    endif()
endif()

target_link_libraries(${PROJECT_NAME}
    PRIVATE
        juce::juce_audio_utils
    PUBLIC
        juce::juce_recommended_config_flags
        juce::juce_recommended_lto_flags
        juce::juce_recommended_warning_flags)
