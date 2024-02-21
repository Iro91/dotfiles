#!/bin/bash -e

#-------------------------------------------------------------------------------
VERBOSE="false"
THIS_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
source "$THIS_DIR/monitor_detect.sh"
WORK_MON="DP-0.1 DP-0.3 eDP-1-1"
STANDALONE="eDP-1-1"

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
    DetectMonitors
    # Set initial resolution
    UpdateResolution "$MONITORS"

    local last="$MONITORS"
    while true; do
        echo "Comparing last"
        if [[ "$last" != "$MONITORS" ]]; then
            UpdateResolution "$MONITORS"
            last="$MONITORS"
        fi
        sleep 10
    done
}

function UpdateResolution() {
    local monitors="$1"
    if [ "$monitors" == "$STANDALONE" ]; then
        SetStandalone
    elif [ "$monitors" == "$WORK_MON" ]; then
        SetWorkResolution
    else
        echo "No known configuration"
        return 0
    fi
    i3-msg reload
}

function SetStandalone() {
    # Configure eDP-1-1
    xrandr --output eDP-1-1 --mode 1920x1200 --pos 5120x450 --rotate normal
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

