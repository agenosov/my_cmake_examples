# Check prerequisites
if(NOT PROJECT_VERSION)
    message(FATAL_ERROR "Product version is not set")
endif()
if(NOT CPACK_WIX_UPGRADE_GUID)
#   See documentation (WiX toolset & CPack WIX generator) about why this is critical
    message(FATAL_ERROR "CPACK_WIX_UPGRADE_GUID is not set")
endif()
#-----------------------------------------------------------------------------------

set(TARGET_MSM_PLATFORM x86)
if(${CMAKE_VS_PLATFORM_NAME} STREQUAL "x64")
    set(TARGET_MSM_PLATFORM ${CMAKE_VS_PLATFORM_NAME})
elseif(${CMAKE_VS_PLATFORM_NAME} STREQUAL "Win32")
    #do nothing
    #We need this workaround, because when building for x86 in MSVS, CMAKE_VS_PLATFORM_NAME is Win32, but WiX Compiler doesn't accept Win32 for -arch option
endif()

set(MERGE_MODULE_PATH ${CMAKE_BINARY_DIR}/${CPACK_PACKAGE_NAME}_${PROJECT_VERSION}_${TARGET_MSM_PLATFORM}.msm)
# According to the docs from Windows Installer, version for MSM should be "major.minor"
set(MERGE_MODULE_VERSION "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}")

# set license file
set(CPACK_WIX_LICENSE_RTF "${PROJECT_SOURCE_DIR}/license.txt")

macro(set_wix_extra_sources _template_src_dir)
    # 1. configure WiX source files
    if(MSVC)
        if (MSVC14)
            set(VC_TOOLSET "VC140")
        elseif (MSVC12)
            set(VC_TOOLSET "VC120")
        elseif (MSVC11)
            set(VC_TOOLSET "VC110")
        elseif (MSVC10)
            set(VC_TOOLSET "VC100")
        else()
            message(FATAL_ERROR "Unsupported MSVC version: ${MSVC_VERSION}")
        endif()
    endif()
    configure_file("${_template_src_dir}/mergeVCRedist.wxs.in"
                   "${CMAKE_BINARY_DIR}/mergeVCRedist.wxs"
                   @ONLY
                  )
    # 2. set additional sources
    set(CPACK_WIX_EXTRA_SOURCES "${CMAKE_BINARY_DIR}/mergeVCRedist.wxs")
endmacro()

# Macro with instructions to build MSI Merge Module
macro(build_msm_module _template_src_dir)
    configure_file("${_template_src_dir}/WIX_MergeModule.wxs.in"
               "${CMAKE_BINARY_DIR}/WIX_MergeModule.wxs")
    # include CMake standard module to locate WiX utils
    include(CPackWIX)
    
    add_custom_target(build_msm ALL)
    add_custom_command(TARGET build_msm
                       COMMAND ${CPACK_WIX_CANDLE_EXECUTABLE} -arch ${TARGET_MSM_PLATFORM} ${CMAKE_BINARY_DIR}/WIX_MergeModule.wxs
                       COMMAND ${CPACK_WIX_LIGHT_EXECUTABLE} -out ${MERGE_MODULE_PATH} ${CMAKE_BINARY_DIR}/WIX_MergeModule.wixobj
                       VERBATIM)
endmacro()