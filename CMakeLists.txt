cmake_minimum_required(VERSION 3.15)
project(GUI_APP_EXAMPLE VERSION 0.0.1)
add_subdirectory(libs/JUCE)

juce_add_plugin(AudioPluginExample
    # VERSION ...                               # Set this if the plugin version is different to the project version
    # ICON_BIG ...                              # ICON_* arguments specify a path to an image file to use as an icon for the Standalone
    # ICON_SMALL ...
    # COMPANY_NAME ...                          # Specify the name of the plugin's author
    # IS_SYNTH TRUE/FALSE                       # Is this a synth or an effect?
    # NEEDS_MIDI_INPUT TRUE/FALSE               # Does the plugin need midi input?
    # NEEDS_MIDI_OUTPUT TRUE/FALSE              # Does the plugin need midi output?
    # IS_MIDI_EFFECT TRUE/FALSE                 # Is this plugin a MIDI effect?
    # EDITOR_WANTS_KEYBOARD_FOCUS TRUE/FALSE    # Does the editor need keyboard focus?
    # COPY_PLUGIN_AFTER_BUILD TRUE/FALSE        # Should the plugin be installed to a default location after building?
    PLUGIN_MANUFACTURER_CODE Juce               # A four-character manufacturer id with at least one upper-case character
    PLUGIN_CODE Dem0                            # A unique four-character plugin id with exactly one upper-case character
                                                # GarageBand 10.3 requires the first letter to be upper-case, and the remaining letters to be lower-case
    FORMATS VST3 Standalone                  # The formats to build. Other valid formats are: AAX Unity VST AU AUv3
    PRODUCT_NAME "Audio Plugin Example")        # The name of the final executable, which can differ from the target name

target_sources(AudioPluginExample
    PRIVATE
        src/PluginEditor.cpp
        src/PluginProcessor.cpp)

target_compile_definitions(AudioPluginExample
    PUBLIC
        JUCE_WEB_BROWSER=0
        JUCE_USE_CURL=0
        JUCE_VST3_CAN_REPLACE_VST2=0)

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
        add_dependencies(GuiAppExample get-local-asio)
        add_dependencies(AudioPluginExample get-local-asio)
        add_dependencies(AudioPluginHost get-local-asio)
    else()
        file(TO_CMAKE_PATH "$ENV{ASIOSDK_DIR}" ASIOSDK_DIR)
        message(STATUS "ASIO SDK found at ${ASIOSDK_DIR}")
        message(STATUS "The resulting standalone executables are not licensed for distribution!")
    endif()

    target_compile_definitions(GuiAppExample PUBLIC JUCE_ASIO=1)
    target_compile_definitions(AudioPluginExample PUBLIC JUCE_ASIO=1)
    target_compile_definitions(AudioPluginHost PUBLIC JUCE_ASIO=1)

    target_include_directories(GuiAppExample PUBLIC ${ASIOSDK_DIR}/common)
    target_include_directories(AudioPluginExample PUBLIC ${ASIOSDK_DIR}/common)
    target_include_directories(AudioPluginHost PUBLIC ${ASIOSDK_DIR}/common)
    set(JUCE_ASIO_SUPPORT TRUE)
endif()

target_link_libraries(AudioPluginExample
    PRIVATE
        # AudioPluginData           # If we'd created a binary data target, we'd link to it here
        juce::juce_audio_utils
    PUBLIC
        juce::juce_recommended_config_flags
        juce::juce_recommended_lto_flags
        juce::juce_recommended_warning_flags)
