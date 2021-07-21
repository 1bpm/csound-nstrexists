set(PLUGIN_NAME nstrexists)

# Dependencies
    # None

# Source files
set(CPPFILES src/opcodes.cpp)
make_plugin(${PLUGIN_NAME} "${CPPFILES}")
target_include_directories(${PLUGIN_NAME} PRIVATE ${CSOUND_INCLUDE_DIRS})
