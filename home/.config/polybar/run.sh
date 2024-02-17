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
    Paint ./cuts/preview.sh
    return 0

    #QuietRun ./blocks/preview.sh
    #QuietRun ./colorblocks/preview.sh
    QuietRun ./cuts/preview.sh
    QuietRun ./docky/preview.sh
    QuietRun ./forest/preview.sh
    #QuietRun ./grayblocks/preview.sh
    QuietRun ./hack/preview.sh
    QuietRun ./material/preview.sh
    #QuietRun ./shades/preview.sh
    #QuietRun ./shapes/preview.sh
}

function QuietRun() {
    echo "Watching $1"
    "$1" &> /dev/null
    #Paint "$1"
    read -r
    killall polybar
}

function Paint() {
    local wp=/home/iro/.config/wallpaper/aurora.jpg
    local cm="$(dirname "$1")/scripts/pywal.sh"
    if [ -e "$cm" ]; then
        echo "$cm" "$wp"
        "$cm" "$wp" || echo "Failed to paint: $cm"
        sleep 1
    fi

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

