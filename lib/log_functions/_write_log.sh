#!/usr/bin/env bash

# Library of functions related to terminal and file logging
# Inspired by https://github.com/gentoo/gentoo-functions/blob/master/functions.sh
#
# @author  Michael Strache
#
# @file
# Defines function: bfl::write_log().
#------------------------------------------------------------------------------

# Prevent this library from being sourced more than once
[[ ${_GUARD_BFL_LOG:-} -eq 1 ]] && return 0 || declare -r _GUARD_BFL_LOG=1


# **************************************************************************** #
# Dependencies                                                                 #
# **************************************************************************** #


# **************************************************************************** #
# Main                                                                         #
# **************************************************************************** #

# *************************************************************************** #
# Colors and formatting                                                       #
#                                                                             #
# The colors defined here are based on the Gentoo Linux color mappings        #
# -> https://wiki.gentoo.org/wiki//etc/portage/color.map                      #
#                                                                             #
# *************************************************************************** #

#
# Clean up before setting anything
#

# Initialize RC_NOCOLOR if it is unset. Set it to 'yes' if you do not want colors to be used
RC_NOCOLOR=${RC_NOCOLOR:-no}

# Reset all colors
unset CLR_GOOD CLR_INFORM CLR_WARN CLR_BAD CLR_HILITE CLR_BRACKET CLR_NORMAL

# Reset all formatting options
unset FMT_BOLD FMT_UNDERLINE


#
# Setup the colors depending on what the terminal supports
#

# Only enable colors if it is wanted
if ! [[ "${RC_NOCOLOR}" =~ ^(YES|Yes|yes)$ ]]; then

  # If tput is present, prefer it over the escape sequence based formatting
  if ( command -v tput ) >/dev/null 2>&1; then
    # tput color table
    # -> http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html

    if [[ $( tput colors ) -ge 256 ]]; then
      declare -r CLR_GOOD="$(tput setaf 10)"     # Bright Green
      declare -r CLR_INFORM="$(tput setaf 2)"    # Green
      declare -r CLR_WARN="$(tput setaf 11)"     # Bright Yellow
      declare -r CLR_BAD="$(tput setaf 9)"       # Bright Red
      declare -r CLR_HILITE="$(tput setaf 14)"   # Bright Cyan
      declare -r CLR_BRACKET="$(tput setaf 12)"  # Bright Blue
      declare -r CLR_NORMAL="$(tput sgr0)"

      # Enable additional formatting for 256 color terminals (on 8 color terminals the formatting likely is implemented as a brighter color rather than a different font)
      declare -r FMT_BOLD="$(tput bold)"
      declare -r FMT_UNDERLINE="$(tput smul)"
    else
      declare -r CLR_GOOD="$(tput bold)$(tput setaf 2)"
      declare -r CLR_INFORM="$(tput setaf 2)"
      declare -r CLR_WARN="$(tput bold)$(tput setaf 3)"
      declare -r CLR_BAD="$(tput bold)$(tput setaf 1)"
      declare -r CLR_HILITE="$(tput bold)$(tput setaf 6)"
      declare -r CLR_BRACKET="$(tput bold)$(tput setaf 4)"
      declare -r CLR_NORMAL="$(tput sgr0)"
    fi
  else
    # Escape sequence color table
    # -> https://en.wikipedia.org/wiki/ANSI_escape_code#Colors

    if [[ "${TERM}" =~ 256color ]]; then
      declare -r CLR_GOOD="$(printf '\033[38;5;10m')"
      declare -r CLR_INFORM="$(printf '\033[38;5;2m')"
      declare -r CLR_WARN="$(printf '\033[38;5;11m')"
      declare -r CLR_BAD="$(printf '\033[38;5;9m')"
      declare -r CLR_HILITE="$(printf '\033[38;5;14m')"
      declare -r CLR_BRACKET="$(printf '\033[38;5;12m')"
      declare -r CLR_NORMAL="$(printf '\033[0m')"

      # Enable additional formatting for 256 color terminals (on 8 color terminals the formatting likely is implemented as a brighter color rather than a different font)
      declare -r FMT_BOLD="$(printf '\033[01m')"
      declare -r FMT_UNDERLINE="$(printf '\033[04m')"
    else
      declare -r CLR_GOOD="$(printf '\033[32;01m')"
      declare -r CLR_INFORM="$(printf '\033[32m')"
      declare -r CLR_WARN="$(printf '\033[33;01m')"
      declare -r CLR_BAD="$(printf '\033[31;01m')"
      declare -r CLR_HILITE="$(printf '\033[36;01m')"
      declare -r CLR_BRACKET="$(printf '\033[34;01m')"
      declare -r CLR_NORMAL="$(printf '\033[0m')"
    fi
  fi
fi

# *************************************************************************** #
# Logging                                                                     #
# *************************************************************************** #

# Define the available log levels
declare -r LOG_LVL_OFF=0
declare -r LOG_LVL_ERR=1
declare -r LOG_LVL_WRN=2
declare -r LOG_LVL_INF=3
declare -r LOG_LVL_DBG=4

# Set defaults
LOG_LEVEL=${LOG_LVL_INF}
LOG_SHOW_TIMESTAMP=false
LOG_FILE=/dev/null

#------------------------------------------------------------------------------
# @function
# Prints the passed message depending on its log-level to stdout.
#
# @param Integer $LEVEL
#   Log level of the message.
#
# @param String $MESSAGE
#   Message to log.
#
# @param String $STATUS
#   Short status string, that will be displayed right aligned in the log line.
#
# @example
#   bfl::write_log 0 "Compiling source" "Start operation"
#------------------------------------------------------------------------------
#
function write_log() {
  local -r LEVEL=${1:-$LOG_LVL_DBG}; shift
  local message="${1:-}"; shift
  local -r STATUS=${1:-}; shift

  if [[ "${LOG_LEVEL}" -ge "${LEVEL}" ]]; then
      [ ${LOG_SHOW_TIMESTAMP} = true ] && message="$(date) - ${message}"

      # To display a right aligned status we have to take some extra efforts
      if [ -z "${STATUS}" ]; then
          echo "${message}"
      else
          # Filter formatting sequences from the STATUS string to get its displayed length
          # https://stackoverflow.com/a/52781213/10495078
          local -r STATUS_filtered="$( sed -E -e "s/\x1B(\[[0-9;]*[JKmsu]|\(B)//g" <<< "$STATUS" )"
          let message_width=$(tput cols)-${#STATUS_filtered}

          printf "\r%-*s%s\n" ${message_width} "${message}" "${STATUS}"
      fi
  fi
}
