#!/bin/bash
set -euo pipefail

SCRIPTDIR=$(cd $(dirname $0); pwd)
BINDIR="${SCRIPTDIR}"
COPYLIBDIR="${SCRIPTDIR}/../../copylib"
DIRNAME=$(basename "${SCRIPTDIR}")

SRCFILE_A="KJBM020.COB"
SRCFILE_B="KCBS010.COB"
cobc -m -o "KCBS010.so" -I"${COPYLIBDIR}" "${SRCFILE_B}"
# -oつけてるときは.SO
SRCFILENAME=$(basename -s .COB $SRCFILE_A)
cobc -x -o "${SRCFILENAME}" -I"${COPYLIBDIR}" "${SRCFILE_A}"
