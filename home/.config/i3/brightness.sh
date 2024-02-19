#!/bin/bash -e

#-------------------------------------------------------------------------------
VERBOSE="false"
UP="false"
DOWN="false"
MONITOR="eDP-1"

#-------------------------------------------------------------------------------
function Usage() {
    cat <<EOF
NAME
$(basename "$0") Rough Description

DESCRIPTION
    Detailed description
    -h  : Print this usage
    -v  : Enable verbosity
    -m  : Enable verbosity
    -u  : Up Brightness
    -d  : Down Brightness
EOF
    exit 0
}

#-------------------------------------------------------------------------------
function Main() {
    [[ $VERBOSE == "true" ]] && set -x

    local increment=0
    [[ $UP == "true" ]] && increment=.1
    [[ $DOWN == "true" ]] && increment=-.1

    if [[ "$(echo "$increment != 0" | bc)" -eq 1 ]]; then
        ChangeBrightness $increment
    fi
    GetBrightness
}

#-------------------------------------------------------------------------------
function ChangeBrightness() {
    local increment="$1"
    local current=0
    current="$(GetBrightness)"

    local applied=1
    applied=$(echo "$current" + "$increment" | bc)
    if [[ "$(echo "$applied < 0" | bc)" -eq 1 ]]; then
        applied=0
    elif [ "$(echo "$applied > 1" | bc)" -eq 1 ]; then
        applied=1
    fi

    xrandr --output "$MONITOR" --brightness $applied
    GetBrightness
}

#-------------------------------------------------------------------------------
function GetBrightness() {
    xrandr --verbose | grep -i "$MONITOR" -A 10 | grep -i "brightness" | cut -d: -f 2
}

#-------------------------------------------------------------------------------
while getopts "hvud" opt; do
    case $opt in
    h) Usage ;;
    v) VERBOSE="true" ;;
    u) UP="true" ;;
    d) DOWN="true" ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
    esac
done
shift $((OPTIND - 1))

#-------------------------------------------------------------------------------
Main "${@}"

