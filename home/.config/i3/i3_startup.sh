#!/bin/bash -e

#-------------------------------------------------------------------------------
VERBOSE="true"
SLEEP_TIME=.5
THIS_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

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
    source "$THIS_DIR/monitor_detect.sh"
    #KillWindows

    # The below are work specific and may or may not be on a given system
    SpawnApp 0 slack "$CENT_MONITOR"
    SpawnApp 1 firefox "$CENT_MONITOR"
    SpawnApp 2 kitty "$CENT_MONITOR"
    SpawnApp 3 kitty "$CENT_MONITOR"
    #SetFloating 2

    SpawnApp 8 zoom "$CENT_MONITOR"
    SpawnApp 9 spotify "$CENT_MONITOR"
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
    sleep "2"
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
Main "${@}"

