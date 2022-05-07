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
    ICON_BIG "${CMAKE_SOURCE_DIR}/resources/logo/logo.png"
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

if(DEFINED ENV{ASIOSDK_DIR} OR BUILD_USING_MY_ASIO_LICENSE)
    if(BUILD_USING_MY_ASIO_LICENSE)
        message(STATUS "** BUILD USING OWN ASIO LICENSE **")
        message(STATUS "The resulting standalone executables are not licensed for distribution!")
        message(STATUS "Fetching ASIO SDK...")
        set(ASIOSDK_DIR ${CMAKE_BINARY_DIR}/asio/asiosdk)
        add_custom_target(get-local-asio)
        add_custom_command(
            TARGET get-local-asio
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
            COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/asio
            COMMAND ${CMAKE_COMMAND} -D ASIO_SDK_DESTINATION=${CMAKE_BINARY_DIR}/asio -P cmake/get-asio.cmake
        )
        add_dependencies(${PROJECT_NAME} get-local-asio)
    else()
        file(TO_CMAKE_PATH "$ENV{ASIOSDK_DIR}" ASIOSDK_DIR)
        message(STATUS "ASIO SDK found at ${ASIOSDK_DIR}")
        message(STATUS "The resulting standalone executables are not licensed for distribution!")
    endif()
    target_compile_definitions(${PROJECT_NAME} PUBLIC JUCE_ASIO=1)
    target_include_directories(${PROJECT_NAME} PUBLIC ${ASIOSDK_DIR}/common)
endif()

target_link_libraries(${PROJECT_NAME}
    PRIVATE
        juce::juce_audio_utils
    PUBLIC
        juce::juce_recommended_config_flags
        juce::juce_recommended_lto_flags
        juce::juce_recommended_warning_flags)
