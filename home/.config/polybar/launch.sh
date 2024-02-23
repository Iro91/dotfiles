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
    if pgrep -u $UID -x polybar &> /dev/null; then
        killall -q polybar
    fi

    # Wait until the processes have been shut down
    while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

    for screen in $(xrandr --query | grep -w "connected" | cut -d" " -f1); do
        export MONITOR="$screen"
        polybar -r bar -c ~/.config/polybar/config.ini &
    done


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

