#!/usr/bin/env bash

! [[ "$BASH_SOURCE" =~ /bash_functions_library ]] && return 0 || _bfl_temporary_var=$(echo "$BASH_SOURCE" | sed 's|^.*/lib/\([^/]*\)/\([^/]*\)\.sh$|_GUARD_BFL_\1\2|')
[[ ${!_bfl_temporary_var} -eq 1 ]] && return 0 || readonly $_bfl_temporary_var=1
#------------------------------------------------------------------------------
# ------------- https://github.com/jmooring/bash-function-library -------------
# @file
# Defines function: bfl::insert_string_to_file().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Inserts string to file. Supports multiline strings!
#
# @param string $str
#   The string to be inserted.
#
# @param Integer $line_no
#   File line number.
#
# @param string $filename
#   The file to be edited.
#
# @example
#   bfl::insert_string_to_file "$str" 288 'Makefile.in'
#------------------------------------------------------------------------------
bfl::insert_string_to_file() {
  bfl::verify_arg_count "$#" 3 3 || { bfl::writelog_fail "${FUNCNAME[0]} arguments count $# ≠ 3"; return $BFL_ErrCode_Not_verified_args_count; } # Verify argument count.

  local -i i
  i=`echo "$2" | wc -l`
  local s
  if [[ $i -gt 1 ]]; then
      # еле-еле вставил - пришлось подставить к кавычкам обратную косую черту
      # дополнительно в конец каждой строки добавить \, кроме самой последней строки
      s=$(echo "$1" | sed 's/"/\"/g;s/[$]/\\\$/g;s/$/\\\/g')
      s="${s::-1}"    # убираем обратную косую черту из конца
  else
      s=$(echo "$1" | sed 's/"/\"/g;s/[$]/\\\$/g')
  fi

  # https://www.programmersought.com/article/93399676487/
  if [ $(uname -s) == "Darwin" ]; then # mac
      sed -i "" "$2""i$s" "$3"
  else # linux
      sed -i "$2""i$s" "$3"
  fi

  return 0
  }
