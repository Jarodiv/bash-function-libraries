#! /dev/null/bash

[[ "$BASH_SOURCE" =~ /bash_functions_library ]] && _bfl_temporary_var=$(echo "$BASH_SOURCE" | sed 's|^.*/lib/\([^/]*\)/\([^/]*\)\.sh$|_GUARD_BFL_\1\2|') || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly $_bfl_temporary_var=1
#------------------------------------------------------------------------------
# ------------ https://github.com/Jarodiv/bash-function-libraries -------------
#
# Library of functions related to terminal and file logging
#
# @author  Michael Strache
#
# @file
# Defines function: bfl::writelog_info().
#------------------------------------------------------------------------------

# **************************************************************************** #
# Dependencies                                                                 #
# **************************************************************************** #
source "${BASH_FUNCTION_LIBRARY%/*}"/lib/logs/_write_log.sh

#------------------------------------------------------------------------------
# @function
#   Prints passed Message on Log-Level info to stdout.
#
# @param String $MESSAGE
#   Message to log.
#
# @param String $STATUS
#   Short status string, that will be displayed right aligned in the log line.
#
# @param String    LogFile (optional)
#   Log file.
#
# @example
#   bfl::writelog_info "some string"
#------------------------------------------------------------------------------
bfl::writelog_info() {
  bfl::verify_arg_count "$#" 1 3 || { # Нельзя bfl::die Verify argument count.
      [[ $BASH_INTERACTIVE == true ]] && printf "${FUNCNAME[0]}: error: arguments count $# ∉ [1, 3]\n" > /dev/tty
      return 1
      }

  # Verify arguments
  bfl::is_blank "$1" && { # Нельзя bfl::die Verify argument count.
      [[ $BASH_INTERACTIVE == true ]] && printf "${FUNCNAME[0]}: parameter 1 is blank!\n" > /dev/tty
      return 1
      }

  local -r msg="$1"
  local -r logfile="${3:-$BASH_FUNCTION_LOG}"
  bfl::write_log $LOG_LVL_INFORM "$msg" "${2:-Info}" "$logfile" || {
      [[ $BASH_INTERACTIVE == true ]] && printf "${FUNCNAME[0]}: error $*\n" > /dev/tty
      return 1
      }

  [[ $BASH_INTERACTIVE == true ]] || return 0
  printf "${CLR_INFORM}$msg${NC}\n" > /dev/tty
  printf "${CLR_INFORM}Written log message to $logfile${NC}\n" > /dev/tty
  return 0
  }
