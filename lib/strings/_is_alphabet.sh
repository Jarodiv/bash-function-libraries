#!/usr/bin/env bash

! [[ "$BASH_SOURCE" =~ /bash_functions_library ]] && return 0 || _bfl_temporary_var=$(echo "$BASH_SOURCE" | sed 's|^.*/lib/\([^/]*\)/\([^/]*\)\.sh$|_GUARD_BFL_\1\2|')
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly $_bfl_temporary_var=1
#------------------------------------------------------------------------------
#----------- https://github.com/natelandau/shell-scripting-templates ----------
#
# Validate that a given input is entirely alphabetic characters
#
# @author  Nathaniel Landau
#
# @file
# Defines function: bfl::is_alpha().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Checks if a string is entirely alphabetic characters.
#
# @param string $str
#   The string to check.
#
# @return boolean $result
#      0 / 1   ( true / false )
#
# @example
#   bfl::is_alpha "foo"
#------------------------------------------------------------------------------
bfl::is_alpha() {
  bfl::verify_arg_count "$#" 1 1 || { bfl::writelog_fail "${FUNCNAME[0]} arguments count $# ≠ 1"; return $BFL_ErrCode_Not_verified_args_count; } # Verify argument count.

  # Check the string.
  [[ -z "$1" ]] && return 0
  [[ "$1" =~ ^[[:alpha:]]+$ ]] && return 0 || return 1
  }
