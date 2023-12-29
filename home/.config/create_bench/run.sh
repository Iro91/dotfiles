#!/bin/bash
set -e

_USAGE=$(cat << EOF
General info
  -h --help:    Prints this usage
  -v --verbose: Enables verbositiy and logging
  -j --threads: Select number of threads to use
EOF
)

THIS_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
LOG_FILE=${THIS_DIR}/"log_"`basename "${0}"`
THREADS=$(nproc)
VERBOSE="false"
GRIND="false"

PARAMS=""
while (( "$#" )); do
  case "$1" in
    -h|--help)
      echo "${_USAGE}"
      exit 0
      ;;
    -v|--verbose)
      VERBOSE="false"
      ;;
    -g|--grind)
      GRIND="true"
      ;;
    -j|--threads)
      THREADS=${2};
      shift
      ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      ;;
  esac
  shift
done
# set positional arguments in their proper place
eval set -- "${PARAMS}"

function f_handle_logging()
{
  echo "Script logs will be stored in ${LOG_FILE}"

  # Move old log file into log directory and time stamp it
  if [ -f ${LOG_FILE} ]; then
    local _logdir=z.logs
    local _ar_log="$(basename ${LOG_FILE})_$(date -r ${LOG_FILE} "+%Y%m%d%H%m%S")"

    mkdir -p ${_logdir}
    mv "${LOG_FILE}" "${_logdir}/${_ar_log}"
    echo "${LOG_FILE}" has been moved to "${_logdir}/${_ar_log}"
  fi
}

function f_main()
{
  set -e
  make -j ${THREADS}
  echo "Build completed with: $?"

  ${THIS_DIR}/Bench
  if [ ${GRIND} == "true" ];then 
    valgrind ${THIS_DIR}/Bench
  fi
  exit 0
}

if [ ${VERBOSE} == "true" ]; then
  f_handle_logging

  set -x
  f_main "${@}" 2>&1 | tee ${LOG_FILE}
else
  f_main "${@}"
fi
