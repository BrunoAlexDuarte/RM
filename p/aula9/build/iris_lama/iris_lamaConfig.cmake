# required by CMakePackageConfigHelpers
# https://cmake.org/cmake/help/latest/module/CMakePackageConfigHelpers.html

####### Expanded from @PACKAGE_INIT@ by configure_package_config_file() #######
####### Any changes to this file will be overwritten by the next CMake run ####
####### The input file was iris_lamaConfig.cmake.in                            ########

get_filename_component(PACKAGE_PREFIX_DIR "${CMAKE_CURRENT_LIST_DIR}/../../../" ABSOLUTE)

macro(set_and_check _var _file)
  set(${_var} "${_file}")
  if(NOT EXISTS "${_file}")
    message(FATAL_ERROR "File or directory ${_file} referenced by variable ${_var} does not exist !")
  endif()
endmacro()

macro(check_required_components _NAME)
  foreach(comp ${${_NAME}_FIND_COMPONENTS})
    if(NOT ${_NAME}_${comp}_FOUND)
      if(${_NAME}_FIND_REQUIRED_${comp})
        set(${_NAME}_FOUND FALSE)
      endif()
    endif()
  endforeach()
endmacro()

####################################################################################

# forward the targets
include(${CMAKE_CURRENT_LIST_DIR}/iris_lamaTargets.cmake)

# define INCLUDE_DIRS and LIBRARIES, required for catkin_package
set_and_check(iris_lama_INCLUDE_DIRS "${PACKAGE_PREFIX_DIR}/include")
set(iris_flama_LIBRARIES iris_lama::iris_lama)

# forward dependencies AFTER expanding the @PACKAGE_<...>@ macros!!!
# otherwise the expanded paths might point to a found package
include(CMakeFindDependencyMacro)
find_dependency(Eigen3 3.3 REQUIRED NO_MODULE)

# labels the packages as found or not
check_required_components(iris_lama)
