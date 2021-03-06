#[[
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
]]
