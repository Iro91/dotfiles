#!/bin/bash -e

#-------------------------------------------------------------------------------
WORK_MON="DP-0.1 DP-0.3 eDP-1-1"
STANDALONE="eDP-1-1"

LEFT_MONITOR=""
MAIN_MONITOR=""
RIGHT_MONITOR=""

MONITORS=""


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
function DetectMonitors() {
    MONITORS="$(xrandr | grep -w connected | cut -d" "  -f 1 | xargs)"
    if [ "$MONITORS" == "$STANDALONE" ]; then
        MAIN_MONITOR="$STANDALONE"
        LEFT_MONITOR="$STANDALONE"
        RIGHT_MONITOR="$STANDALONE"
    elif [ "$MONITORS" == "$WORK_MON" ]; then
        MAIN_MONITOR="DP-0.1"
        LEFT_MONITOR="DP-0.3"
        RIGHT_MONITOR="$STANDALONE"
    fi
    echo "$MONITORS"
    echo "$MAIN_MONITOR"
    echo "$LEFT_MONITOR"
    echo "$RIGHT_MONITOR"
}
