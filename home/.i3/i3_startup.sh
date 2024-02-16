#!/bin/bash -e

#-------------------------------------------------------------------------------
VERBOSE="false"
LEFT_MONITOR=""
MAIN_MONITOR=""
RIGHT_MONITOR=""

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
    SpawnApp 4 slack
    SpawnApp 5 zoom
}

function SpawnApp() {
    local ws=$1
    local app=$2
    if command -v "$app" &> /dev/null; then
        i3-msg "workspace $ws; exec $app"
    fi
}

#-------------------------------------------------------------------------------
#function DetectMinitors() {
#    local monitors="1"
#    monitors="$(xrandr | grep -wc "connected")"
#    if [ "$monitors" -eq 3 ]; then
#        echo "There are three monitors"
#    elif [ "$monitors" -eq 2 ]; then
#        echo "There are two monitors"
#    else
#    fi
#}

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

