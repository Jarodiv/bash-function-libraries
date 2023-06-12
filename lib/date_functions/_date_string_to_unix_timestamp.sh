#!/usr/bin/env bash

! [[ "$BASH_SOURCE" =~ /bash_functions_library ]] && return 0 || _bfl_temporary_var=$(echo "$BASH_SOURCE" | sed 's|^.*/lib/\([^/]*\)/\([^/]*\)\.sh$|_GUARD_BFL_\1\2|')
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly $_bfl_temporary_var=1
#------------------------------------------------------------------------------
#----------- https://github.com/natelandau/shell-scripting-templates ----------
# Functions to help work with dates and time
#
# @file
# Defines function: bfl::date_string_to_unix_timestamp().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Convert date string to unix timestamp.
#
# @param String $str
#   Date to be converted.
#
# @return boolean $result
#   timestamp for specified date/time.
#
# @example
#   printf "%s\n" "$(bfl::date_string_to_unix_timestamp "Jan 10, 2019")"
#------------------------------------------------------------------------------
#
bfl::date_string_to_unix_timestamp() {
  bfl::verify_arg_count "$#" 1 1 || { bfl::writelog_fail "${FUNCNAME[0]} arguments count $# ≠ 1"; return $BFL_ErrCode_Not_verified_args_count; } # Verify argument count.

  local dt
  dt=$(date -d "$1" +"%s") || return 1
  printf "%s\n" "$dt"

  return 0
  }
