#!/bin/bash -e

#-------------------------------------------------------------------------------
VERBOSE="true"
SLEEP_TIME=.5
THIS_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
source "$THIS_DIR/monitor_detect.sh"

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
    #KillWindows

    # The below are work specific and may or may not be on a given system
    DetectMonitors
    SpawnApp 1 firefox "$MAIN_MONITOR"
    SpawnApp 2 kitty "$MAIN_MONITOR"
    SetFloating 2

    SpawnApp 3 slack "$LEFT_MONITOR"
    SpawnApp 4 zoom "$RIGHT_MONITOR"
    SpawnApp 0 spotify "$RIGHT_MONITOR"
}

function KillWindows() {
    # List all windows
    windows=$(i3-msg -t get_tree | jq '.. | (.nodes? // empty)[] | select(.window!=null) | .id')

    # Close all windows
    for win in $windows; do
        i3-msg "[con_id=$win]" kill
        sleep "$SLEEP_TIME"
    done
}

function SpawnApp() {
    local ws=$1
    local app=$2
    local screen=$3
    if command -v "$app" &> /dev/null; then
        if ! pgrep -i "$app" &> /dev/null; then
            i3-msg "workspace $ws; exec $app"
        fi
        i3-msg "workspace $ws, move workspace to output $screen"
    fi
    sleep "1"
}

function SetFloating() {
    local ws=$1
    i3-msg "workspace $ws; floating enable"
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
Main "${@}" &> /tmp/restart.txt

