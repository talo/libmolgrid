# function to convert Doxygen-style comments into Python-style docstrings
function(doxyToDoc DOCSTRING DOXYSTRING)
  string(REGEX REPLACE "\brief " "" DOCSTRING "${DOXYSTRING}")
  if("${DOXYSTRING}" MATCHES "@param ([a-zA-Z0-9_]+) (.*)")
    set(DOXYSTRING ":param ${CMAKE_MATCH_1}: ${CMAKE_MATCH_2}")
  endif()
  if ("${DOXYSTRING}" MATCHES "@return (.+)")
    set(DOXYSTRING ":returns: ${CMAKE_MATCH_1}")
  endif()
  set(DOCSTRING ${DOCSTRING} ${DOXYSTRING} PARENT_SCOPE)
endfunction()

# automatically generate docstrings in bindings from Doxygen annotations in cpp header files
file(READ "bindings.cpp.in" CONTENTS)
STRING(REGEX REPLACE ";" "\\\\;" CONTENTS "${CONTENTS}")
string(REGEX REPLACE "\n" ";" CONTENTS "${CONTENTS}")

# make list of object names for retrieval later
foreach(LINE ${CONTENTS})
  if("${LINE}" MATCHES ".*\"@(Docstring_[a-zA-Z0-9_]+)@\"\);")
    set(OBJS ${OBJS} ${CMAKE_MATCH_1})
  endif()
endforeach()

# find the headers
file(GLOB HEADERS  ${PROJECT_SOURCE_DIR}/include/libmolgrid)

# make map of object name to docstring content
set(COPYING "0")
foreach(fname ${HEADERS})
  file(READ fname HEADER_CONTENTS)
  STRING(REGEX REPLACE ";" "\\\\;" HEADER_CONTENTS "${HEADER_CONTENTS}")
  string(REGEX REPLACE "\n" ";" HEADER_CONTENTS "${HEADER_CONTENTS}")
  foreach(LINE ${HEADER_CONTENTS})
    # extract Doxygen 
    if("${LINE}" MATCHES "[ \t]+// (Docstring_[a-zA-Z0-9_]+)")
      set(COPYING "1")
      set(FUNC ${CMAKE_MATCH_1})
    # continuing extraction of previous comment
    elseif(${COPYING} AND "${LINE}" MATCHES "(/\*|\*)([\*]+)([a-zA-Z0-9@\\\.\(\)]+)")
      doxyToDoc(DOCSTRING LINE)
    # insert into map, zero out string
    elseif(${COPYING})
      string(REPLACE ";" "\\n" DOCSTRING "${DOCSTRING}")
      set(${FUNC} ${DOCSTRING})
      set(COPYING "0")
      set(DOCSTRING "")
    endif()
  endforeach()
endforeach()

# insert docstrings into bindings
configure_file("bindings.cpp.in" "bindings.cpp" @ONLY)
