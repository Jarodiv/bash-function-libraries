#!/usr/bin/env bats
#shellcheck disable

# Unittests for the functions in lib/system
#
# The unit tests in this script are written using the BATS framework.
# See: https://github.com/sstephenson/bats


# **************************************************************************** #
# Imports                                                                      #
# **************************************************************************** #
[[ ${_GUARD_BFL_autoload} -eq 1 ]] || { . ${HOME}/getConsts; . "$BASH_FUNCTION_LIBRARY"; }


# **************************************************************************** #
# Init                                                                         #
# **************************************************************************** #

# **************************************************************************** #
# Test Casses                                                                  #
# **************************************************************************** #

# ---------------------------------------------------------------------------- #
# System::Path::remove_entry                                                   #
# ---------------------------------------------------------------------------- #
