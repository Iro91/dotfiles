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
    SetWorkResolution
}

function SetWorkResolution() {
    # Configure DP-0.1
    xrandr --output DP-0.1 --mode 2560x1440 --pos 2560x0 --rotate normal

    # Configure DP-0.3
    xrandr --output DP-0.3 --mode 2560x1440 --pos 0x0 --rotate normal

    # Configure eDP-1-1
    xrandr --output eDP-1-1 --mode 1920x1200 --pos 5120x450 --rotate normal
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

