#! /dev/null/bash

[[ "$BASH_SOURCE" =~ /bash_functions_library ]] && _bfl_temporary_var=$(echo "$BASH_SOURCE" | sed 's|^.*/lib/\([^/]*\)/\([^/]*\)\.sh$|_GUARD_BFL_\1\2|') || return 0
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly $_bfl_temporary_var=1
#------------------------------------------------------------------------------
# ----------------- https://github.com/ariver/bash_functions ------------------
#
# Library of functions related to the vcsh
#
# @author  A. River
#
# @file
# Defines function: bfl::vcsh_untracked().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
#   ..............................
#
# @return Boolean $result
#     0 / 1   ( true / false )
#
# @example
#   bfl::vcsh_untracked
#------------------------------------------------------------------------------
bfl::vcsh_untracked() {
#  bfl::verify_arg_count "$#" 1 999 || { bfl::writelog_fail "${FUNCNAME[0]} arguments count $# ∉ [1, 999]"; return ${BFL_ErrCode_Not_verified_args_count}; }  # Verify argument count.
  bfl::verify_dependencies "vcsh"   || { bfl::writelog_fail "${FUNCNAME[0]}: dependency 'vcsh' not found";   return ${BFL_ErrCode_Not_verified_dependency}; }  # Verify dependencies.

  { printf '/%s\n' \
          .DS_Store .Trash .cache .local .opt .rnd Applications Desktop Documents Downloads Library Maildirs Movies Music Pictures Public
  vcsh list-tracked | sed "s=^${HOME}\(/[^/]*\).*=\1=" | sort -u
  } > "${XDG_CONFIG_HOME:-${HOME}/.config}/vcsh/ignore.d/vcsh-untracked"
  vcsh run vcsh-untracked git status -sb || { bfl::writelog_fail "${FUNCNAME[0]}: Failed vcsh run vcsh-untracked git status -sb"; return 1; }

  return 0
  }