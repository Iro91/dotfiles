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

    Must be run as root
EOF
    exit 0
}

#-------------------------------------------------------------------------------
function Main() {
    [[ "$EUID" -ne 0 ]] && { echo "ERROR: This application must run as root." >&2; exit 1; }
    [[ $VERBOSE == "true" ]] && set -x
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

