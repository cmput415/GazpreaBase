include_directories("${CMAKE_SOURCE_DIR}/dialect_include/Gazprea")

add_mlir_dialect_library(MLIRGazprea
        GazpreaTypes.cpp
        GazpreaDialect.cpp
        GazpreaOps.cpp
        GazpreaPasses.cpp

        ADDITIONAL_HEADER_DIRS
        ${PROJECT_SOURCE_DIR}/dialect_include/GazpreaDialect

        DEPENDS
	MLIRGazpreaOpsIncGen
        MLIRGazpreaPassesIncGen

	# LINK_COMPONENTS PUBLIC
        # MLIRIR
        )
