#!/bin/bash -e

#-------------------------------------------------------------------------------
VERBOSE="false"
THIS_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
LOG_FILE="$THIS_DIR/$(basename "$0")_$(date "+%Y%m%d_%H%m%S").log"
THREADS=$(nproc)
VERBOSE="false"
GRIND="false"

#-------------------------------------------------------------------------------
function Usage() {
    cat <<EOF
NAME
$(basename "$0") Builds out the target folder and executes the binary underneath

DESCRIPTION
    Detailed description
    -h  : Print this usage
    -v  : Enable verbosity and logging
    -j  : Select number of threads to use to build app
    -g  : Attach valgrind to build product
EOF
    exit 0
}

#-------------------------------------------------------------------------------
while getopts "hvgj:" opt; do
    case $opt in
    h) Usage ;;
    v) VERBOSE="true" ;;
    g) GRIND="true" ;;
    j) THREADS=$OPTARG ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
    esac
done
shift $((OPTIND - 1))

#-------------------------------------------------------------------------------
function Main() {
  make -j "${THREADS}"
  echo "Build completed with: $?"

  "${THIS_DIR}"/Bench
  if [ "${GRIND}" == "true" ];then 
    valgrind "${THIS_DIR}/Bench"
  fi
  exit 0
}

#-------------------------------------------------------------------------------
if [ "$VERBOSE" == "true" ]; then
    echo "Script logs will be stored in $LOG_FILE"
    set -x
    mkdir -p "$(dirname "$LOG_FILE")"

    Main 2>&1 | tee "$LOG_FILE"
else
    Main
fi

