#! /dev/null/bash

[[ "$BASH_SOURCE" =~ /bash_functions_library ]] && _bfl_temporary_var=$(echo "$BASH_SOURCE" | sed 's|^.*/lib/\([^/]*\)/\([^/]*\)\.sh$|_GUARD_BFL_\1\2|') || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly $_bfl_temporary_var=1
#------------------------------------------------------------------------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of functions related to pb
#
# @author  A. River
#
# @file
# Defines function: bfl::pbpaste_flat().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   Runs pbpaste
#
# @example
#   bfl::pbpaste_flat
#------------------------------------------------------------------------------
bfl::pbpaste_flat() {
  bfl::verify_dependencies "pbpaste" || { bfl::writelog_fail "${FUNCNAME[0]}: dependency 'pbpaste' not found"; return ${BFL_ErrCode_Not_verified_dependency}; }  # Verify dependencies.
  pbpaste | tr -s '[:space:]' ' '
  }