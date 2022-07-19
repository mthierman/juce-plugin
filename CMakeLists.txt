cmake_minimum_required(VERSION 3.20)
project(TestPlugin VERSION 0.0.1 LANGUAGES C CXX ASM)
set(CMAKE_CXX_STANDARD 17)
add_subdirectory(libs/JUCE EXCLUDE_FROM_ALL)

math(EXPR BITNESS "${CMAKE_SIZEOF_VOID_P} * 8" OUTPUT_FORMAT DECIMAL)
message(STATUS "${PROJECT_NAME} ${BITNESS}-bit, version ${PROJECT_VERSION}, ${CMAKE_BUILD_TYPE} build")
message(STATUS "CMake version ${CMAKE_VERSION}, Compiler version ${CMAKE_CXX_COMPILER_VERSION}")

juce_add_gui_app(${PROJECT_NAME}
    # VERSION ...                       # Set this if the app version is different to the project version
    # ICON_BIG ...                      # ICON_* arguments specify a path to an image file to use as an icon
    # ICON_SMALL ...
    # DOCUMENT_EXTENSIONS ...           # Specify file extensions that should be associated with this app
    # COMPANY_NAME ...                  # Specify the name of the app's author
    PRODUCT_NAME ${PROJECT_NAME})     # The name of the final executable, which can differ from the target name

target_sources(${PROJECT_NAME}
  PRIVATE
    src/Main.cpp
    src/MainComponent.cpp)

target_compile_definitions(${PROJECT_NAME}
    PRIVATE
        # JUCE_WEB_BROWSER and JUCE_USE_CURL would be on by default, but you might not need them.
        JUCE_WEB_BROWSER=0  # If you remove this, add `NEEDS_WEB_BROWSER TRUE` to the `juce_add_gui_app` call
        JUCE_USE_CURL=0     # If you remove this, add `NEEDS_CURL TRUE` to the `juce_add_gui_app` call
        JUCE_APPLICATION_NAME_STRING="$<TARGET_PROPERTY:${PROJECT_NAME},JUCE_PRODUCT_NAME>"
        JUCE_APPLICATION_VERSION_STRING="$<TARGET_PROPERTY:${PROJECT_NAME},JUCE_VERSION>")

target_link_libraries(${PROJECT_NAME}
    PRIVATE
        # GuiAppData            # If we'd created a binary data target, we'd link to it here
        juce::juce_gui_extra
    PUBLIC
        juce::juce_recommended_config_flags
        juce::juce_recommended_lto_flags
        juce::juce_recommended_warning_flags)
