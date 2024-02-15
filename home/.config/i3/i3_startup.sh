#!/bin/bash -e

#-------------------------------------------------------------------------------
VERBOSE="false"

#-------------------------------------------------------------------------------
function Usage() {
    cat <<EOF
NAME
$(basename "$0") Rough Description

DESCRIPTION
    Detailed description
    -h  : Print this usage
    -v  : Enable verbosity
EOF
    exit 0
}

#-------------------------------------------------------------------------------
function Main() {
    [[ $VERBOSE == "true" ]] && set -x

    sleep 1
    # Web browser for fun stuff
    i3-msg "workspace 1; exec firefox"
    # Web browser for work resarch
    i3-msg "workspace 2; exec firefox"
    # Open up a terminal
    i3-msg "workspace 3; exec i3-sensible-terminal"

    # The below are work specific and may or may not be on a given system
    if command -v slack &> /dev/null; then
        i3-msg "workspace 4; exec slack"
    fi
    if command -v zoom &> /dev/null; then
        i3-msg "workspace 5; exec zoom"
    fi
}

#-------------------------------------------------------------------------------
while getopts "hv" opt; do
    case $opt in
    h) Usage ;;
    v) VERBOSE="true" ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
    esac
done
shift $((OPTIND - 1))

#-------------------------------------------------------------------------------
Main "${@}"

