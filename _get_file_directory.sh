#!/usr/bin/env bash

#------------------------------------------------------------------------------
# @file
# Defines function: lib::get_file_directory().
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# @function
# Gets the canonical path to the directory in which a file resides.
#
# @param string $path
#   A relative path, absolute path, or symlink.
#
# @return string $canonical_directory_path
#   The canonical path to the directory in which a file resides.
#------------------------------------------------------------------------------
lib::get_file_directory() {
  lib::validate_arg_count "$#" 1 1 || return 1
  declare -r path="$1"
  declare canonical_directory_path
  declare canonical_file_path

  if lib::is_empty "${path}"; then
    lib::err "Error: the path was not specified."
    return 1
  fi

  canonical_file_path=$(lib::get_file_path "${path}") || return 1
  canonical_directory_path=$(dirname "${canonical_file_path}}")

  printf "%s" "${canonical_directory_path}"
}