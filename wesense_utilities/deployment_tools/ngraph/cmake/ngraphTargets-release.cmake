#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "ngraph::ngraph" for configuration "Release"
set_property(TARGET ngraph::ngraph APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(ngraph::ngraph PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libngraph.so"
  IMPORTED_SONAME_RELEASE "libngraph.so"
  )

list(APPEND _IMPORT_CHECK_TARGETS ngraph::ngraph )
list(APPEND _IMPORT_CHECK_FILES_FOR_ngraph::ngraph "${_IMPORT_PREFIX}/lib/libngraph.so" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
