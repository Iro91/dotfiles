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
    KillWindows

    # The below are work specific and may or may not be on a given system
    SpawnApp 1 firefox
    SpawnApp 2 firefox
    SpawnApp 3 kitty

    SpawnApp 4 slack
    SpawnApp 5 zoom
    SpawnApp 0 spotify
}

function KillWindows() {
    # List all windows
    windows=$(i3-msg -t get_tree | jq '.. | (.nodes? // empty)[] | select(.window!=null) | .id')

    # Close all windows
    for win in $windows; do
        i3-msg "[con_id=$win]" kill
        sleep 1
    done
}

function SpawnApp() {
    local ws=$1
    local app=$2
    if command -v "$app" &> /dev/null; then
        i3-msg "workspace $ws; exec $app"
    fi
    sleep 1
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

