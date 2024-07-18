#!/bin/bash
set -euo pipefail

SCRIPTDIR=$(cd $(dirname $0); pwd)
BINDIR="${SCRIPTDIR}"
COPYLIBDIR="${SCRIPTDIR}/../../copylib"
DIRNAME=$(basename "${SCRIPTDIR}")

SRCFILE="KJBM030.COB"
# -oつけてるときは.SO
SRCFILENAME=$(basename -s .COB $SRCFILE)
cobc -x -o "${SRCFILENAME}" -I"${COPYLIBDIR}" "${SRCFILE}"
