#!/bin/bash -e

#-------------------------------------------------------------------------------
VERBOSE="false"
LOOP="false"
FORCE="false"

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
LAST_DETECTED="/tmp/$(basename "$0" .sh)"

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
    -f  : Force the monitor resolution to reload
EOF
    exit 0
}

#-------------------------------------------------------------------------------
function DetectMonitors() {
    MONITORS="$(xrandr | grep -w connected | cut -d" "  -f 1 | sort | xargs)"
    xrandr | grep -w connected | sort > "$LAST_DETECTED"

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

function ResolutionMonitor() {
    local deltaCheck="${LAST_DETECTED}.delta"
    while true; do
        if [[ -f "$LAST_DETECTED" ]]; then
            cp -p "$LAST_DETECTED" "$deltaCheck"
        fi
        DetectMonitors

        if ! diff "$deltaCheck" "$LAST_DETECTED"; then
            UpdateResolution
        fi

        sleep 10
    done
}

function UpdateResolution() {
    # We just have the laptop
    if [[ "$MONITORS" == "$LAPTOP" ]]; then
        xrandr $CENT_RESOLUTION
    else
        xrandr $LEFT_RESOLUTION
        xrandr $CENT_RESOLUTION
        xrandr $RIGHT_RESOLUTION
    fi
    i3-msg reload
}

#-------------------------------------------------------------------------------
while getopts "hvlf" opt; do
    case $opt in
    h) Usage ;;
    v) VERBOSE="true" ;;
    l) LOOP="true" ;;
    f) FORCE="true" ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
    esac
done
shift $((OPTIND - 1))

#-------------------------------------------------------------------------------
[[ $VERBOSE == "true" ]] && set -x

DetectMonitors

# Loop forever monitoring for output changes
if [[ "$LOOP" == "true" ]]; then
    ResolutionMonitor
# Force the displays to update
elif [[ "$FORCE" == "true" ]]; then
    UpdateResolution
fi
