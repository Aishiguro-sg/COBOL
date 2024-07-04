#!/bin/bash
set -euo pipefail

SCRIPTDIR=$(cd $(dirname $0); pwd)
BINDIR="${SCRIPTDIR}"
COPYLIBDIR="${SCRIPTDIR}/../../copylib"
DIRNAME=$(basename "${SCRIPTDIR}")

SRCFILE="KJBM020.COB"
SRCFILENAME=$(basename -s .COB $SRCFILE)
cobc -x -v -o "${SRCFILENAME}" -I"${COPYLIBDIR}" "${SRCFILE}"
