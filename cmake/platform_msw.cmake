cmake_minimum_required( VERSION 3.0 FATAL_ERROR )

set( CMAKE_VERBOSE_MAKEFILE ON )

# Add any linux-specific .cpp files...
list( APPEND SRC_SET_DS_CINDER_LINUX
)

list( APPEND DS_CINDER_SRC_FILES
	${SRC_SET_DS_CINDER_LINUX}
)

# Common libs for Linux.

#Poco
if( TRUE )
	set( POCO_LIB_DIRECTORY "${DS_CINDER_PATH}/lib/poco" )
	list( APPEND DS_CINDER_INCLUDE_SYSTEM_PUBLIC "${POCO_LIB_DIRECTORY}/include" )
	list( APPEND DS_CINDER_LIBS_DEPENDS
		${POCO_LIB_DIRECTORY}/lib//${DS_CINDER_ARCH}/libPocoNetmt.lib
		${POCO_LIB_DIRECTORY}/lib//${DS_CINDER_ARCH}/libPocoFoundationmt.lib
		# TODO: Use Debug libs?
		#${POCO_LIB_DIRECTORY}/libPocoNetd.a
		#${POCO_LIB_DIRECTORY}/libPocoFoundationd.a
	)
else()
	find_package( Poco REQUIRED )
	list( APPEND DS_CINDER_INCLUDE_SYSTEM_PUBLIC ${POCO_INCLUDE_DIR} )
	if( CMAKE_BUILD_TYPE STREQUAL "Debug" )
		list( APPEND DS_CINDER_LIBS_DEPENDS ${POCO_LIB_FOUNDATION_DEBUG} )
		list( APPEND DS_CINDER_LIBS_DEPENDS ${POCO_LIB_NET_DEBUG} )
	else()
		list( APPEND DS_CINDER_LIBS_DEPENDS ${POCO_LIB_FOUNDATION} )
		list( APPEND DS_CINDER_LIBS_DEPENDS ${POCO_LIB_NET} )
	endif()
endif()

# Cinder
#list( APPEND DS_CINDER_INCLUDE_SYSTEM_PUBLIC "${CINDER_PATH}/include" )
#list( APPEND CINDER_LIBS_DEPENDS ${CINDER_PATH}/lib/linux/x86_64/ogl/${CMAKE_BUILD_TYPE}/libcinder.a )
#list( APPEND DS_CINDER_LIBS_DEPENDS ${CINDER_LIBRARIES} )
#list( APPEND DS_CINDER_INCLUDE_SYSTEM_PUBLIC ${CINDER_INCLUDE_DIRS} )
# pull in cinder's exported configuration
include( "${CINDER_PATH}/proj/cmake/configure.cmake" )
if( NOT TARGET cinder )
	find_package( cinder REQUIRED PATHS
		"${CINDER_PATH}/${CINDER_LIB_DIRECTORY}"
		"$ENV{CINDER_PATH}/${CINDER_LIB_DIRECTORY}"
	)
endif()

## Populate DS_CINDER_INCLUDE_SYSTEM_PRIVATE
## Populate DS_CINDER_LIBS_DEPENDS

# Glib
# GObject
# Cairo
# Pango
# PangoCairo
# Freetype2
# FontConfig

# cURL
# Snappy
# Sqlite3

# Glib
# find_package( Glib REQUIRED )
set( GLIB_LIB_DIRECTORY "${DS_CINDER_PATH}/lib/gtk" )
list( APPEND DS_CINDER_LIBS_DEPENDS "${GLIB_LIB_DIRECTORY}/lib64/glib-2.0.lib" )
list( APPEND DS_CINDER_INCLUDE_SYSTEM_PRIVATE "${DS_CINDER_PATH}/src/gtk/glib-2.0/glib" )

# GObject
set( GOBJECT_LIB_DIRECTORY "${DS_CINDER_PATH}/lib/gtk" )
list( APPEND DS_CINDER_LIBS_DEPENDS "${GOBJECT_LIB_DIRECTORY}/lib64/gobject-2.0.lib" )
list( APPEND DS_CINDER_INCLUDE_SYSTEM_PRIVATE "${DS_CINDER_PATH}/src/gtk/glib-2.0/gobject" )

# Cairo
set( CAIRO_LIB_DIRECTORY "${DS_CINDER_PATH}/lib/gtk" )
list( APPEND DS_CINDER_LIBS_DEPENDS "${CAIRO_LIB_DIRECTORY}/lib64/cairo-2.0.lib" )
list( APPEND DS_CINDER_INCLUDE_SYSTEM_PRIVATE "${DS_CINDER_PATH}/src/gtk/cairo" )
# find_package( Cairo REQUIRED )
# list( APPEND DS_CINDER_LIBS_DEPENDS ${Cairo_LIBRARIES} )
# list( APPEND DS_CINDER_INCLUDE_SYSTEM_PRIVATE ${Cairo_INCLUDE_DIRS} )

# Pango
set( PANGO_LIB_DIRECTORY "${DS_CINDER_PATH}/lib/gtk" )
list( APPEND DS_CINDER_LIBS_DEPENDS "${PANGO_LIB_DIRECTORY}/lib64/pango-1.0.lib" )
list( APPEND DS_CINDER_INCLUDE_SYSTEM_PRIVATE "${DS_CINDER_PATH}/src/gtk/pango-1.0" )
# find_package( Pango REQUIRED COMPONENTS )
# list( APPEND DS_CINDER_LIBS_DEPENDS ${Pango_LIBRARIES} )
# list( APPEND DS_CINDER_INCLUDE_SYSTEM_PRIVATE ${Pango_INCLUDE_DIRS} )

# PangoCairo
set( PANGO_LIB_DIRECTORY "${DS_CINDER_PATH}/lib/gtk" )
list( APPEND DS_CINDER_LIBS_DEPENDS "${PANGO_LIB_DIRECTORY}/lib64/pangocairo-1.0.lib" )
# list( APPEND DS_CINDER_INCLUDE_SYSTEM_PRIVATE "${DS_CINDER_PATH}/src/gtk/pango-1.0" )
# find_package( PangoCairo REQUIRED )
# list( APPEND DS_CINDER_LIBS_DEPENDS ${PangoCairo_LIBRARIES} )
# list( APPEND DS_CINDER_INCLUDE_SYSTEM_PRIVATE ${PangoCairo_INCLUDE_DIRS} )

# Freetype2
set( FREETYPE_LIB_DIRECTORY "${DS_CINDER_PATH}/lib/gtk" )
set( Freetype_LIBRARY "${FREETYPE_LIB_DIRECTORY}/lib64/freetype.lib" )
set( Freetype_INCLUE_DIR "${DS_CINDER_PATH}/src/gtk/freetype2" )

list( APPEND DS_CINDER_LIBS_DEPENDS "${Freetype_LIBRARY}" )
list( APPEND DS_CINDER_INCLUDE_SYSTEM_PRIVATE "${Freetype_INCLUE_DIR}" )
# find_package( Freetype REQUIRED )
# list( APPEND DS_CINDER_LIBS_DEPENDS ${Freetype_LIBRARIES} )
# list( APPEND DS_CINDER_INCLUDE_SYSTEM_PRIVATE ${Freetype_INCLUDE_DIRS} )

# FontConfig

set( FONTCONFIG_LIB_DIRECTORY "${DS_CINDER_PATH}/lib/gtk" )
set( Fontconfig_LIBRARY "${FONTCONFIG_LIB_DIRECTORY}/lib64/fontconfig.lib" )
set( Fontconfig_INCLUE_DIR "${DS_CINDER_PATH}/src/gtk/fontconfig" )

list( APPEND DS_CINDER_LIBS_DEPENDS "${Fontconfig_LIBRARY}" )
list( APPEND DS_CINDER_INCLUDE_SYSTEM_PRIVATE "${Fontconfig_INCLUE_DIR}" )
# find_package( FontConfig REQUIRED )
# list( APPEND DS_CINDER_LIBS_DEPENDS ${FONTCONFIG_LIBRARIES} )
# list( APPEND DS_CINDER_INCLUDE_SYSTEM_PRIVATE ${FONTCONFIG_INCLUDE_DIRS} )

# Curl
# set( PANGO_LIB_DIRECTORY "${DS_CINDER_PATH}/lib/gtk" )
# list( APPEND DS_CINDER_LIBS_DEPENDS "${PANGO_LIB_DIRECTORY}/lib64/pango-1.0.lib" )
# list( APPEND DS_CINDER_INCLUDE_SYSTEM_PRIVATE "${DS_CINDER_PATH}/src/gtk/pango-1.0" )
# find_package( CURL REQUIRED )
# list( APPEND DS_CINDER_LIBS_DEPENDS ${CURL_LIBRARIES} )
# list( APPEND DS_CINDER_INCLUDE_SYSTEM_PRIVATE ${CURL_INCLUDE_DIR} )

# Snappy
if( TRUE )
	set( SNAPPY_LIB_DIRECTORY "${DS_CINDER_PATH}/lib/snappy" )
	list( APPEND DS_CINDER_INCLUDE_SYSTEM_PUBLIC "${SNAPPY_LIB_DIRECTORY}" )
	list( APPEND DS_CINDER_LIBS_DEPENDS
		${SNAPPY_LIB_DIRECTORY}/lib64/snappy64.lib
	)
else()
	find_package( Snappy REQUIRED )
	list( APPEND DS_CINDER_LIBS_DEPENDS ${Snappy_LIBRARIES} )
	list( APPEND DS_CINDER_INCLUDE_SYSTEM_PRIVATE ${Snappy_INCLUDE_DIRS} )
endif()

# Sqlite3
# set( SQLITE3_LIB_DIRECTORY "${DS_CINDER_PATH}/lib/gtk" )
# list( APPEND DS_CINDER_LIBS_DEPENDS "${SQLITE3_LIB_DIRECTORY}/lib64/sqlite3-1.0.lib" )
# list( APPEND DS_CINDER_INCLUDE_SYSTEM_PRIVATE "${DS_CINDER_PATH}/src/gtk/sqlite3-1.0" )
# find_package( Sqlite3 REQUIRED )
# list( APPEND DS_CINDER_LIBS_DEPENDS ${Sqlite3_LIBRARIES} )
# list( APPEND DS_CINDER_INCLUDE_SYSTEM_PRIVATE ${Sqlite3_INCLUDE_DIRS} )

# GStreamer and its dependencies.
# GStreamer
list( APPEND DS_CINDER_LIBS_DEPENDS "${GSTREAMER_1_0_ROOT_MSVC_X86_64}/lib/" )
list( APPEND DS_CINDER_INCLUDE_SYSTEM_PRIVATE "${Fontconfig_INCLUE_DIR}" )

# find_package( GStreamer REQUIRED )
# list( APPEND DS_CINDER_LIBS_DEPENDS 
# 	${GSTREAMER_LIBRARIES}
# 	${GSTREAMER_BASE_LIBRARIES}
# 	${GSTREAMER_APP_LIBRARIES}
# 	${GSTREAMER_VIDEO_LIBRARIES}
# )
# list( APPEND DS_CINDER_INCLUDE_SYSTEM_PRIVATE
# 	${GSTREAMER_INCLUDE_DIRS}
# 	${GSTREAMER_BASE_INCLUDE_DIRS}
# 	${GSTREAMER_APP_INCLUDE_DIRS}
# 	${GSTREAMER_VIDEO_INCLUDE_DIRS}
# )

# If we have gst-gl available add it.
if( GSTREAMER_GL_INCLUDE_DIRS AND GSTREAMER_GL_LIBRARIES )
	list( APPEND DS_CINDER_LIBS_DEPENDS ${GSTREAMER_GL_LIBRARIES} )
	list( APPEND DS_CINDER_INCLUDE_SYSTEM_PRIVATE ${GSTREAMER_GL_INCLUDE_DIRS} )
endif()

# Boost
if( DS_CINDER_BOOST_USE_SYSTEM )
	find_package( Boost 1.54 REQUIRED COMPONENTS system filesystem )
	list( APPEND DS_CINDER_LIBS_DEPENDS ${Boost_LIBRARIES} )
	list( APPEND DS_CINDER_INCLUDE_SYSTEM_PRIVATE ${Boost_INCLUDE_DIRS} )
else()
	set( CINDER_LINUX_LIB_DIRECTORY "${CINDER_PATH}/lib/linux/${DS_CINDER_ARCH}/" )
	list( APPEND DS_CINDER_LIBS_DEPENDS
		${CINDER_LINUX_LIB_DIRECTORY}/libboost_system.a
		${CINDER_LINUX_LIB_DIRECTORY}/libboost_filesystem.a
	)
endif()

# Workaround for gcc bug on versions > 5.3.1 when building as a shared lib.
#if( CMAKE_COMPILER_IS_GNUCXX AND CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 5.3.1 AND BUILD_SHARED_LIBS )
#list( APPEND DS_CINDER_LIBS_DEPENDS gcc )
#endif()

if( NOT DS_CINDER_BOOST_USE_SYSTEM )
	execute_process( COMMAND gcc -dumpversion OUTPUT_VARIABLE GCC_VERSION )
	if( GCC_VERSION VERSION_GREATER 5.1 OR GCC_VERSION VERSION_EQUAL 5.1 )
		message( STATUS "Version >= 5.1 -- Disabling _GLIBCXX_USE_CXX11_ABI." )
		list( APPEND DS_CINDER_DEFINES "-D_GLIBCXX_USE_CXX11_ABI=0" )
		if( CMAKE_COMPILER_IS_GNUXX )
			set( CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} -Wabi-tag ) 
		endif()
	endif()
endif()

