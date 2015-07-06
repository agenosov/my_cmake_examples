if(NOT CPACK_WIX_ROOT)
  file(TO_CMAKE_PATH "$ENV{WIX}" CPACK_WIX_ROOT)
endif()

find_program(WIX_HEAT_EXECUTABLE heat
  PATHS "${CPACK_WIX_ROOT}/bin")

if(NOT WIX_HEAT_EXECUTABLE)
  message(FATAL_ERROR "Could not find the WiX heat executable.")
endif()