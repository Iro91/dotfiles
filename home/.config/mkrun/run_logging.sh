#!/bin/bash -e

#-------------------------------------------------------------------------------
VERBOSE="false"
LOGGING="false"
THIS_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
LOG_FILE="$THIS_DIR/$(basename "$0")_$(date "+%Y%m%d_%H%m%S").log"

#-------------------------------------------------------------------------------
function Usage() {
    cat <<EOF
NAME
$(basename "$0") Rough Description

DESCRIPTION
    -h: Prints this usage
    -v: Enable verbosity
    -e: Edit this script
    -l: Enables script logging
EOF
    exit 0
}

#-------------------------------------------------------------------------------
function Main() {
    [[ $VERBOSE == "true" ]] && set -x
}

#-------------------------------------------------------------------------------
while getopts "hvl" opt; do
    case $opt in
    h) Usage ;;
    v) VERBOSE="true" ;;
    l) LOGGING="true" ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
    esac
done
shift $((OPTIND - 1))

#-------------------------------------------------------------------------------
if [ $LOGGING == "true" ]; then
    echo "Script logs will be stored in $LOG_FILE"
    mkdir -p "$(dirname "$LOG_FILE")"

    Main "${@}" 2>&1 | tee "$LOG_FILE"
else
    Main "${@}"
fi

