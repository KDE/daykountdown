# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles/daykountdown_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/daykountdown_autogen.dir/ParseCache.txt"
  "daykountdown_autogen"
  )
endif()
