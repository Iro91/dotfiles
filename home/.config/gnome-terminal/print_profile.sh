#!/bin/bash -e

#-------------------------------------------------------------------------------
VERBOSE="false"

#-------------------------------------------------------------------------------
function Usage() {
    cat <<EOF
NAME
$(basename "$0") Prints the dconf values of the current gnome profile

DESCRIPTION
    Detailed description
    -h  : Print this usage
    -v  : Enable verbosity
EOF
    exit 0
}

#-------------------------------------------------------------------------------
# Currently we print out the entire gnome terminal profile suite. If we try
# to load a single entry, gnome freaks out unless we have created ap profiel
# to accommodate the load
function LoadCurrentProfile(){
    local profile=/org/gnome/terminal/legacy/profiles:
    #local current=$(dconf read $profile/default | tr -d "'")
    #dconf dump "$profile/:$current/"
    dconf dump "$profile/"
}

#-------------------------------------------------------------------------------
function Main() {
    [[ $VERBOSE == "true" ]] && set -x
    LoadCurrentProfile
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

