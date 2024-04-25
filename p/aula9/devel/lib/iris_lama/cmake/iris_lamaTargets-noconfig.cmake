#----------------------------------------------------------------
# Generated CMake target import file.
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "iris_lama::iris_lama" for configuration ""
set_property(TARGET iris_lama::iris_lama APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(iris_lama::iris_lama PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_NOCONFIG "C;CXX"
  IMPORTED_LOCATION_NOCONFIG "${_IMPORT_PREFIX}/lib/libiris_lama.a"
  )

list(APPEND _IMPORT_CHECK_TARGETS iris_lama::iris_lama )
list(APPEND _IMPORT_CHECK_FILES_FOR_iris_lama::iris_lama "${_IMPORT_PREFIX}/lib/libiris_lama.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
