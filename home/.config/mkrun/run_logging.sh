#!/bin/bash

set -e

LOG_FILE="/var/tmp/logs/$(basename "$0")_$(date "+%Y%m%d%H%m%S")"
LOGGING="false"
VERBOSE="false"

#-------------------------------------------------------------------------------
function Usage() {
    cat <<EOF
NAME
$(basename $0) Rough Description

DESCRIPTION
    -h: Prints this usage
    -v: Enable verbosity
    -e: Edit this script
    -l: Enables script logging
EOF
}

#-------------------------------------------------------------------------------
function Main() {
    [[ $VERBOSE == "true" ]] && set -x
}

#-------------------------------------------------------------------------------
while getopts "hvel" opt; do
    case $opt in
    h) Usage ;;
    v) set -x ;;
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
    mkdir -p $(dirname "$LOG_FILE")

    Main 2>&1 | tee $LOG_FILE
else
    Main
fi

