set(CPACK_PACKAGING_INSTALL_PREFIX "/opt/${CPACK_PACKAGE_INSTALL_DIRECTORY}")

#-------------------------------------
#Settings specific to RPM generator
#TODO


#-------------------------------------
# Settings specific to Debian generator

set(CPACK_DEBIAN_PACKAGE_MAINTAINER "John Doe <jdoe@mycompany.com>")

# Specify dependencies from other packages, and recommended packages
#set(CPACK_DEBIAN_PACKAGE_DEPENDS "")
#set(CPACK_DEBIAN_PACKAGE_RECOMMENDS "")

if(NOT CPACK_DEBIAN_PACKAGE_SECTION)
    SET(CPACK_DEBIAN_PACKAGE_SECTION non-free)
endif()

# Configure conffiles for Debian (the conffiles lists files which are not to be used to calc checksums)
configure_file(${CMAKE_CURRENT_LIST_DIR}/../contrib/deb/conffiles.in
               ${CMAKE_BINARY_DIR}/conffiles
              )
set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA "${CMAKE_BINARY_DIR}/conffiles")
