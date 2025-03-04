file(REMOVE_RECURSE
  "../liblogger.a"
  "../liblogger.pdb"
)

# Per-language clean rules from dependency scanning.
foreach(lang )
  include(CMakeFiles/logger.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
