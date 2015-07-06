Example of using CMake in conjunction with CPack to produce packages for:
* Linux (.rpm and .deb packages)
* Windows (.msi package, merge modules for .msi)

## Usage on Linux
...

## Usage on Windows
* mkdir build && cd build
* cmake .. -G"Visual Studio 11 Win64"
* cmake --build . --config Release

This commands builds Merge Module for Windows Installer (.msm module would be located inside build directory) 

### Build MSI using Wix Toolset
* cd build
* cpack -G WIX -C Release