#!/usr/bin/env bash

! [[ "$BASH_SOURCE" =~ /bash_functions_library ]] && return 0 || _bfl_temporary_var=$(echo "$BASH_SOURCE" | sed 's|^.*/lib/\([^/]*\)/\([^/]*\)\.sh$|_GUARD_BFL_\1\2|')
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly $_bfl_temporary_var=1
# ------------------ https://github.com/labbots/bash-utility ------------------
#----------- https://github.com/natelandau/shell-scripting-templates ----------
# @file
# Defines function: bfl::get_confirm().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Seek user input for yes/no question.
#
# @param String $qstn
#   Question being asked.
#
# @return String   $result
# 		0 / 1  (yes / no)
#
# @example
#   bfl::get_confirm "Do something?" && printf "okay" || printf "not okay"
#     OR
#   if bfl::get_confirm "Answer this question"; then
#     ....
#   fi
#------------------------------------------------------------------------------
bfl::get_confirm() {
  bfl::verify_arg_count "$#" 0 0 || { bfl::writelog_fail "${FUNCNAME[0]} arguments count $# ≠ 0"; return $BFL_ErrCode_Not_verified_args_count; } # Verify argument count.

  ! [[ $BASH_INTERACTIVE == true ]] && return 0   # чтобы не зависла вдруг при загрузке

  local _yesNo
  printf "$1\n" > /dev/tty
  if "${FORCE:-}"; then
      printf "Forcing confirmation with '--force' flag set\n" > /dev/tty
      return 0
  fi

  while true; do
      read -r -p " (y/n) " _yesNo
      case ${_yesNo} in
          [Yy]*) return 0 ;;
          [Nn]*) return 1 ;;
          *)  printf "Please answer yes or no.\n" > /dev/tty ;;
      esac
  done

  return 0
  }
