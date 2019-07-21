#!/usr/bin/env bash

#------------------------------------------------------------------------------
# @file
# Defines function: lib::implode().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Combines multiple strings into a single string, separated by another string.
#
# This function will accept an unlimited number of arguments.
# Example: lib::implode "," "This is" "a" "test."
#
# @param string $glue
#   The character or characters that will be used to glue the strings together.
# @param array $pieces
#   One dimensional array of strings to be combined.
#
# @return string $imploded_string
#   Example: "This is,a,test."
#
# shellcheck disable=SC2154
#-----------------------------------------------------------------------------
lib::implode() {
  # Validate argument count. We cannot call lib::validate_arg_count() from within
  # this function, because lib::validate_arg_count() calls lib::err() which calls
  # lib::implode()... an endless loop.
  if [[ "$#" -lt "2" ]]; then
    message="Error: invalid number of arguments (expected at least 2, received $#)."
    echo -e "${red}${message} ${yellow}[${FUNCNAME[0]}]${reset}" >&2
    return 1
  fi
  declare -r glue="$1"
  # Delete the first positional parameter.
  shift
  # Create the pieces array from the remaining positional parameters.
  declare -a pieces=("$@")
  declare imploded_string

  while (( "${#pieces[@]}" )); do
    if [[ "${#pieces[@]}" -eq "1" ]]; then
      imploded_string+=$(printf "%s\n" "${pieces[0]}")
    else
      imploded_string+=$(printf "%s%s" "${pieces[0]}" "${glue}")
    fi
    pieces=("${pieces[@]:1}")   # Shift the first element off of the array.
  done

  printf "%s" "${imploded_string}"
}