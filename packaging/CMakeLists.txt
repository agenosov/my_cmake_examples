cmake_minimum_required(VERSION 3.2 FATAL_ERROR)
project(MyPackage_CPackIntro VERSION 0.0.1 LANGUAGES CXX)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})

# Install
set(RUNTIME_INSTALL_DIR ./)
install(FILES
        ${CMAKE_CURRENT_SOURCE_DIR}/README.md
		DESTINATION ${RUNTIME_INSTALL_DIR}
		RENAME README)
        
include(MyPackageSettings)

if(WIN32)
    set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/WIX ${CMAKE_MODULE_PATH})
    
    # explicitly set GUID to installers to replace existing installations
    set(CPACK_WIX_UPGRADE_GUID "00B05BAE-ACFC-40BC-8F87-8B526B3ED097")
    
    include(MyPackageWIX)
    
    # override MSI template included with CMake
    set(CPACK_WIX_TEMPLATE "${PROJECT_SOURCE_DIR}/cmake/WIX/WIX.template.in")
    
    # provide additional WiX sources
    set_wix_extra_sources(${PROJECT_SOURCE_DIR}/cmake/WIX)
    
    # build MSI Merge Module
    build_msm_module(${PROJECT_SOURCE_DIR}/cmake/WIX)
endif()

include(CPack)


