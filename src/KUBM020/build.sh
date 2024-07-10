#!/bin/bash
set -euo pipefail

SCRIPTDIR=$(cd $(dirname $0); pwd)
BINDIR="${SCRIPTDIR}"
COPYLIBDIR="${SCRIPTDIR}/../../copylib"
DIRNAME=$(basename "${SCRIPTDIR}")

SRCFILE="KUBM020.COB"
# -oつけてるときは.SO
SRCFILENAME=$(basename -s .COB $SRCFILE)
cobc -x -o "${SRCFILENAME}" -I"${COPYLIBDIR}" "${SRCFILE}"