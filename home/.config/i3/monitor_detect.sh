#!/bin/bash -ex

#-------------------------------------------------------------------------------
VERBOSE="false"
LOOP="false"

WORK_SETUP="DP-0.1 DP-0.3 eDP-1-1"
HOME_SETUP="DP-0 eDP-1-1 HDMI-0"
LAPTOP="eDP-1-1"

LEFT_MONITOR=""
CENT_MONITOR=""
RIGHT_MONITOR=""

LEFT_RESOLUTION=""
CENT_RESOLUTION=""
RIGHT_RESOLUTION=""

MONITORS=""
LAST_SETUP="/tmp/monitor_setup.txt"

#-------------------------------------------------------------------------------
function Usage() {
    cat <<EOF
NAME
$(basename "$0") Rough Description

DESCRIPTION
    Detailed description
    -h  : Print this usage
    -v  : Enable verbosity
    -l  : Loop, starts this process as a persistent service
EOF
    exit 0
}

#-------------------------------------------------------------------------------
function DetectMonitors() {
    MONITORS="$(xrandr | grep -w connected | cut -d" "  -f 1 | sort | xargs)"

    # My laptop is always on the right hand side
    CENT_MONITOR="$LAPTOP"
    if [ "$MONITORS" == "$LAPTOP" ]; then
        LEFT_MONITOR="$LAPTOP"
        CENT_MONITOR="$LAPTOP"
        RIGHT_MONITOR="$LAPTOP"

        CENT_RESOLUTION="--output $LAPTOP --mode 1920x1200 --pos 0x0 --rotate normal"

    elif [ "$MONITORS" == "$WORK_SETUP" ]; then
        LEFT_MONITOR="DP-0.3"
        CENT_MONITOR="DP-0.1"
        RIGHT_MONITOR="$LAPTOP"

        LEFT_RESOLUTION="--output $LEFT_MONITOR --mode 2560x1440 --pos 0x0 --rotate normal"
        CENT_RESOLUTION="--output $CENT_MONITOR --mode 2560x1440 --pos 2560x0 --rotate normal"
        RIGHT_RESOLUTION="--output $RIGHT_MONITOR --mode 1920x1200 --pos 5120x450 --rotate normal"

    elif [ "$MONITORS" == "$HOME_SETUP" ]; then
        LEFT_MONITOR="DP-0"
        CENT_MONITOR="HDMI-0"
        RIGHT_MONITOR="$LAPTOP"

        LEFT_RESOLUTION="--output $LEFT_MONITOR --mode 1920x1200 --pos 0x0 --rotate normal"
        CENT_RESOLUTION="--output $CENT_MONITOR --mode 1920x1200 --pos 1920x0 --rotate normal"
        RIGHT_RESOLUTION="--output $RIGHT_MONITOR --mode 1920x1200 --pos 3840x20 --rotate normal"
    fi

    echo "$MONITORS"
    echo "Left : $LEFT_RESOLUTION"
    echo "Cent : $CENT_RESOLUTION"
    echo "Right: $RIGHT_RESOLUTION"
}

function UpdateResolution() {
    local lastSetup=""
    if [[ -f "$LAST_SETUP" ]]; then
        lastSetup="$(cat $LAST_SETUP)"
    fi
    DetectMonitors

    if [[ "$lastSetup" == "$MONITORS" ]]; then
        echo "Monitor setup matches last, nothing to do"
        return 0
    fi

    # We just have the laptop
    if [[ "$MONITORS" == "$LAPTOP" ]]; then
        xrandr $CENT_RESOLUTION
    else
        xrandr $LEFT_RESOLUTION
        xrandr $CENT_RESOLUTION
        xrandr $RIGHT_RESOLUTION
    fi
    i3-msg reload

    # Cache last setup
    echo "$MONITORS" > "$LAST_SETUP"
}

#-------------------------------------------------------------------------------
while getopts "hvl" opt; do
    case $opt in
    h) Usage ;;
    v) VERBOSE="true" ;;
    l) LOOP="true" ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
    esac
done
shift $((OPTIND - 1))

#-------------------------------------------------------------------------------
[[ $VERBOSE == "true" ]] && set -x

if [[ "$LOOP" == false ]]; then
    DetectMonitors
else
    while true; do
        UpdateResolution
        sleep 10
    done
fi

